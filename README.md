# What got published in [_A List Apart_](http://alistapart.com/), 1999-2016

A short exercise in Web scraping.

- Author: [Fr.](http://f.briatte.org/)
- Language: [R](https://www.r-project.org/).

## HOWTO

1. Run `00-init.r` after installing its package dependencies.
2. Run `01-data.r` as many times as needed to collect all raw data and process it.
3. Run `02-plots.r` to generate summary plots.

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

### `ala_refs.csv`

Contains the edge list of article cross-citations:

* `i` -- `url` of the citing article (source)
* `j` -- `url` of the cited article (target)
* `n` -- number of times the citation occurs in the source

Note that a few (7) articles do not show up as sources in the edge list because of HTML parsing errors. The problem is explained in detailed in [this Stack Overflow post](http://stackoverflow.com/q/41532698/635806).

### `ala_tags.csv`

Contains the general and specific topics of the articles:

* `parent` -- general topic
* `tag` -- specific (child) topic

Since general topics are also used to categorise articles, the `parent` and `tag` columns (parent and child) are sometimes identical.

## CREDITS

- [Bob Rudis](https://rud.is/b/) for [helping with the parser](http://stackoverflow.com/a/41534790/635806).
- [Hadley Wickham](http://hadley.nz/) wrote most of the R packages used.
- [Jeffrey Zeldman](http://www.zeldman.com/) founded _A List Apart_.

## NOTE

All _A List Apart_ articles are [Copyright © 1998–2017 A List Apart & Authors](http://alistapart.com/about/copyright).

Please do not redistribute the raw data for this project.
