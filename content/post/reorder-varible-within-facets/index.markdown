---
title: 'Reordering within facets'
author: Qiushi Yan
date: '2019-11-29'
slug: reorder-varible-within-facets

image:
  caption: "Photo by [Leah Kelley](https://www.pexels.com/@leah-kelley-50725)"
  focal_point: ""
  preview_only: true
categories:
  - R
  - Data Visualization

summary: '{ggetxt} provides convenient yet less-recognized graphing helpers to reorder an x or y axis within facets.'
lastmod: '2020-04-05T21:38:24+08:00'
bibliography: ../bib/reorder-within.bib
link-citations: true
---

This blog post is inspired by Julia Silge’s [Reordering and facetting for ggplot2](https://juliasilge.com/blog/reorder-within/). By reproducing the original post using another different dataset, I hope this could still shed some light on a handful of ggplot2 tips.

# Common words in Jane Austen’s books

Here is a simple task: we want to find the top-10 most common words in several Jane Austen’s books, draw a bar graph, and then put them into different facets.

``` r
library(tidyverse)
#> Warning: package 'tibble' was built under R version 4.1.1
library(tidytext)
library(janeaustenr)
```

Here we use `unnest_tokens` from the `tidytext` package ([Robinson and Silge 2019](#ref-R-tidytext)) to break the text into individual tokens and transform it into a tidy structure:

``` r
# calculate 10 most common words in each book
common_words <- austen_books() %>%
  unnest_tokens(word, text) %>% 
  anti_join(stop_words) %>% 
  count(book, word) %>% 
  group_by(book) %>% 
  top_n(10)

common_words
#> # A tibble: 60 x 3
#> # Groups:   book [6]
#>    book                word           n
#>    <fct>               <chr>      <int>
#>  1 Sense & Sensibility dashwood     231
#>  2 Sense & Sensibility edward       220
#>  3 Sense & Sensibility elinor       623
#>  4 Sense & Sensibility jennings     199
#>  5 Sense & Sensibility marianne     492
#>  6 Sense & Sensibility miss         210
#>  7 Sense & Sensibility mother       213
#>  8 Sense & Sensibility sister       229
#>  9 Sense & Sensibility time         239
#> 10 Sense & Sensibility willoughby   181
#> # ... with 50 more rows
```

For details many and other useful text mining techniques in R, I recommend reading [Text mining with R: A tidy approach](Text%20Mining%20with%20R:%20A%20tidy%20approach) by Julia Silge and David Robinson([2017](#ref-silge2017text)).

``` r
common_words %>% 
  ggplot(aes(y = word, 
             x = n, 
             fill = book)) +
  geom_col(show.legend = FALSE) + 
  facet_wrap(~ book, ncol = 2, scales = "free_y") + 
  theme(axis.text.y = element_text(size = 12),
        axis.text.x = element_text(size = 14)) +
  rcartocolor::scale_fill_carto_d(palette = "PurpOr") + 
  labs(title = "Top 10 commono words in Jane Austen's novels, default ordering",
       y = NULL,
       x = "# of words")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-5-1.png" width="960" />
(**Reminder**: don’t forget `scales = "free_y"` or `scales = "free"` in this case.)

By default, ggplot2 order y lables alphabetically, because they are of type character. One common solution is to use `fct_reorder()` or its equivalent `reorder()` in baes R\`:

``` r
common_words %>% 
  ggplot(aes(y = fct_reorder(word, n), 
             x = n, 
             fill = book)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ book, ncol = 2, scales = "free_y") + 
  theme(axis.text.y = element_text(size = 12),
        axis.text.x = element_text(size = 14)) +
  rcartocolor::scale_fill_carto_d(palette = "PurpOr") + 
  labs(y = NULL,
       title = "fct_reorder() on y",
       x = "# of words")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-6-1.png" width="960" />

Well, our plot improve a bit, but is still wanting in some respects. In each facet, the order of words is not strictly in line with its frequency. In fact, `fct_reorder` or `reorder` only reorder all of these together, meaning that `word` are reordered in an overall level so that it cannot guarantee order in any specific subset of data.

# Helper functions for reordering

tidytext provides 2 helper functions to reorder a variable on a facet level.

`reorder_within()` takes three arguments:

-   `x`: the item we want to reorder  
-   `by`: what we want to reorder by  
-   `within`: the groups or categories we want to reorder within

After that, we use `scale_x_reordered()`(or `scale_y_reordered()`) to finish the plot, these 2 scales can take any argument in common scale functions(e.g., `name`, `labels`, `expand`).

Here is the final plot:

``` r
# reorder word by n, within each book
common_words %>% 
  ggplot(aes(y = reorder_within(word, n, book), 
             x = n, 
             fill = book)) +
  geom_col(show.legend = FALSE) + 
  scale_y_reordered() + 
  facet_wrap(~ book, ncol = 2, scales = "free_y") + 
  theme(axis.text.y = element_text(size = 12),
        axis.text.x = element_text(size = 14)) +
  rcartocolor::scale_fill_carto_d(palette = "PurpOr") +
  labs(title = "Reordering with {ggtext} graph helpers",
       x = "# of words",
       y = NULL)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-7-1.png" width="960" />

Without `scale_y_reordered` which overides ggplot2’s default scale, the label of the reordered variable will carry a suffix related to the group variable, making lables way too long and uninformative.

``` r
common_words %>% 
  ggplot(aes(y = reorder_within(word, n, book), 
             x = n, 
             fill = book)) +
  geom_col(show.legend = FALSE) + 
  facet_wrap(~ book, ncol = 2, scales = "free_y") + 
  theme(axis.text.y = element_text(size = 12),
        axis.text.x = element_text(size = 14)) +
  rcartocolor::scale_fill_carto_d(palette = "PurpOr") +
  labs(title = "Without scale_y_reordered()",
       x = "# of words",
       y = NULL)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-8-1.png" width="1152" />

# References

Nowosad, J. (2018). ‘CARTOColors’ Palettes. R package version 1.0.0. https://nowosad.github.io/rcartocolor

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-R-tidytext" class="csl-entry">

Robinson, David, and Julia Silge. 2019. *Tidytext: Text Mining Using ’Dplyr’, ’Ggplot2’, and Other Tidy Tools*. <https://CRAN.R-project.org/package=tidytext>.

</div>

<div id="ref-silge2017text" class="csl-entry">

Silge, Julia, and David Robinson. 2017. *Text Mining with r: A Tidy Approach*. " O’Reilly Media, Inc.".

</div>

</div>
