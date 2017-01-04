# What got published in [_A List Apart_](http://alistapart.com/), 1999-2016

A short exercise in Web scraping.

- Author: [Fr.](http://f.briatte.org/)
- Language: [R](https://www.r-project.org/).

## HOWTO

1. Run `00-init.r` after installing its package dependencies.
-  Run `01-data.r` as many times as needed to collect all raw data and process it.
-  Run `02-plots.r` to generate summary plots.

## DATA

### `ala_data.csv`

Contains information on all [_A List Apart_ articles](http://alistapart.com/articles) published between 1999 (inception) and 2016:

* `date` -- date of publication, in `yyyy-mm-dd` format
* `url` -- URI
* `tags` -- topic(s), semicolon-separated (see `ala_tags.csv` for a description)
* `au_url` -- URI(s) of the author(s), semicolon-separated
* `au_id` -- name(s) of the author(s), semicolon-separated
* `title` -- title
* `description` -- short article description, from the `<meta>` tag

A single article is missing (`/article/xhtml`), and _A List Apart_ blog posts published between 2013 and 2015 are downloaded but excluded from the `ala_data.csv` dataset.

### `ala_tags.csv`

Contains the general and specific topics of the articles:

* `parent` is a general topic
* `tag` is a specific topic

Since general topics are also used to categorise articles, the `parent` and `tag` columns are sometimes identical.

## CREDITS

- [Hadley Wickham](http://hadley.nz/) wrote most of the R packages used.
- [Jeffrey Zeldman](http://www.zeldman.com/) founded _A List Apart_.

## NOTE

All _A List Apart_ articles are [Copyright © 1998–2017 A List Apart & Authors](http://alistapart.com/about/copyright).

Please do not redistribute the raw data for this project.
