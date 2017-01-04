# ==============================================================================
# TOPICS
# ==============================================================================

if (!file.exists(f_tags)) {
  
  write_csv(
    read_html("http://alistapart.com/articles") %>%
      html_nodes("article.topic ul") %>%
      lapply(function(x) {
        data_frame(
          parent = html_node(x, "li.parent-topic a") %>%
            html_attr("href") %>%
            str_replace("/topic/", ""),
          tag = html_nodes(x, "li a") %>%
            html_attr("href") %>%
            str_replace("/topic/", "")
        )
      }) %>%
      bind_rows,
    f_tags
  )
  
}

# ==============================================================================
# ARTICLES
# ==============================================================================

cat("Source:", r <- "http://alistapart.com", "\n")

if (!file.exists(f_list)) {
  
  d <- data_frame()
  
  i <- str_c(r, "/articles")
  
  while (length(i) > 0) {
    
    cat("Downloading article listing", i, "\n")
    h <- read_html(i)
    
    d <- rbind(d, data_frame(
      topic = i,
      title = html_nodes(h, "ul.entry-list h3.entry-title") %>%
        html_text,
      url = html_nodes(h, "ul.entry-list h3.entry-title a") %>%
        html_attr("href"),
      date = html_nodes(h, "ul.entry-list p.meta time") %>%
        html_attr("datetime"),
      au_url = html_nodes(h, "ul.entry-list p.meta") %>% 
        lapply(html_nodes, "a.author") %>% 
        lapply(html_attr, "href") %>% 
        sapply(str_c, collapse = ";"),
      au_id = html_nodes(h, "ul.entry-list p.meta") %>% 
        lapply(html_nodes, "a.author") %>% 
        lapply(html_text) %>% 
        sapply(str_c, collapse = ";")
    ))
    
    i <- html_nodes(h, "nav.paginator ul li a.previous") %>%
      html_attr("href")
    
  }
  
  stopifnot(!duplicated(d$url))
  
  write_csv(d, f_list)
  
}

# ==============================================================================
# DOWNLOAD ARTICLES
# ==============================================================================

u <- str_c(r, read_csv(f_list, col_types = s_list)$url)
stopifnot(!duplicated(u))

f <- file.path("raw", str_c(basename(u), ".html")) %>%
  file.exists %>%
  sum

if (f != length(u)) {
  
  cat("Downloading articles...\n")
  p <- txtProgressBar(0, length(u), style = 3)
  
  for (i in u) {
    
    f <- file.path("raw", str_c(basename(i), ".html"))
    if (!file.exists(f)) {
      try(download.file(i, f, mode = "wb", quiet = TRUE), silent = TRUE)
    }
    setTxtProgressBar(p, which(u == i))
    
  }
  
}

cat("\n")

# ==============================================================================
# DETAILS
# ==============================================================================

d <- read_csv(f_list, col_types = s_list) %>%
  select(url) %>%
  mutate(description = NA_character_, tags = NA_character_)

if (!file.exists(f_info)) {

  cat("Parsing articles...\n")
  u <- rev(d$url[ is.na(d$description) ])
  p <- txtProgressBar(0, length(u), style = 3)
  
  for (i in u) {
    
    setTxtProgressBar(p, which(u == i))
    
    h <- file.path("raw", str_c(basename(i), ".html")) %>%
      read_html
    
    j <- which(d$url == i)

    if (!html_nodes(h, "meta[name='description']") %>%
        length) {
      
      warning("Skipped:", d$url[ j ])
      next
      
    }
    
    d$description[ j ] <- html_nodes(h, "meta[name='description']") %>%
      html_attr("content")
    
    d$tags[ j ] <- html_nodes(h, "p.entry-details span.entry-meta a") %>%
      lapply(html_attr, "href") %>%
      str_c(collapse = ";") %>%
      ifelse(length(.), ., NA)
    
  }
  
  cat("\n")
  write_csv(d, f_info)
  
}

# ==============================================================================
# FINALIZE
# ==============================================================================

d <- left_join(
  read_csv(f_info, col_types = s_info),
  read_csv(f_list, col_types = s_list) %>%
    select(-page),
  by = "url"
)

d$date <- as.Date(d$date)
d$url <- str_replace(d$url, "^/article/", "")
d$tags <- str_replace_all(d$tags, "/topic/", "")
d$au_url <- str_replace_all(d$au_url, "/author/", "")

# empty fields:

sum(is.na(d$description)) # 0
sum(is.na(d$tags))        # ~ 156

# special authors:

table(d$au_id[ str_detect(d$au_id, "[A-Z0-9]{2,}") ])

d <- select(d, date, url, tags, au_url, au_id, title, description) %>%
  mutate(year = str_sub(date, 1, 4) %>%
           as.integer) %>%
  filter(year %in% 1999:2016) %>% # drop single 2017 article
  filter(!is.na(tags)) # drop blog posts, 2013-2015

write_csv(d, f_data)

# show dataset:

glimpse(d)

# kthxbye
