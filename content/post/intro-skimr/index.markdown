---
title: Skimming through {skimr}
author: Qiushi Yan
date: '2019-11-22'
slug: introduction-to-skimr

summary: 'Develpoed by the rOpenSci conmmunity, skimr is designed to provide useful, tidy summary statistics of data frames'

bibliography: ../bib/introduction-to-skimr.bib
link-citations: true
lastmod: '2020-04-05T23:27:44+08:00'
categories:
  - R

image:
  caption: 'Photo by [Josh Sorenson](https://www.pexels.com/@joshsorenson)'
  focal_point: ''
  preview_only: no

---

# `skim()` basics

The **skimr**([Waring et al. 2019](#ref-R-skimr)) package is developed by the [rOpenSci](https://github.com/ropensci) cummunity, with its core function `skim()` as an enhanced version of `summary()`, and has just experienced a major update to V2. For a more comprehensive guide towards its features, please visit its [vignette](https://docs.ropensci.org/skimr/index.html).[^1]

What `skim()` returns can be divided into 2 parts:

-   **Data summary**: an overview of the input data frame, including **\#** of rows and columns, column types and if the data frame is grouped  
-   **Summary of column variables based on their types, with one section per variable type and one row per variable**: For instance, all numerical variables are explained by missing rate, quantiles (`fivenum()`), mean, standard deviation and a tiny inline histogram. With factors, the count of top values are returned instaed.

``` r
library(skimr)
library(tidyverse)
```

``` r
skim(iris)
```

|                                                  |      |
|:-------------------------------------------------|:-----|
| Name                                             | iris |
| Number of rows                                   | 150  |
| Number of columns                                | 5    |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |      |
| Column type frequency:                           |      |
| factor                                           | 1    |
| numeric                                          | 4    |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |      |
| Group variables                                  | None |

Table 1: Data summary

**Variable type: factor**

| skim\_variable | n\_missing | complete\_rate | ordered | n\_unique | top\_counts               |
|:---------------|-----------:|---------------:|:--------|----------:|:--------------------------|
| Species        |          0 |              1 | FALSE   |         3 | set: 50, ver: 50, vir: 50 |

**Variable type: numeric**

| skim\_variable | n\_missing | complete\_rate | mean |   sd |  p0 | p25 |  p50 | p75 | p100 | hist  |
|:---------------|-----------:|---------------:|-----:|-----:|----:|----:|-----:|----:|-----:|:------|
| Sepal.Length   |          0 |              1 | 5.84 | 0.83 | 4.3 | 5.1 | 5.80 | 6.4 |  7.9 | ▆▇▇▅▂ |
| Sepal.Width    |          0 |              1 | 3.06 | 0.44 | 2.0 | 2.8 | 3.00 | 3.3 |  4.4 | ▁▆▇▂▁ |
| Petal.Length   |          0 |              1 | 3.76 | 1.77 | 1.0 | 1.6 | 4.35 | 5.1 |  6.9 | ▇▁▆▇▂ |
| Petal.Width    |          0 |              1 | 1.20 | 0.76 | 0.1 | 0.3 | 1.30 | 1.8 |  2.5 | ▇▁▇▅▃ |

The second argument `...` in `skim()` could specify any number of variables to be included, similar to `dplyr::select()`:

``` r
skim(iris, Sepal.Width, Species)
```

|                                                  |      |
|:-------------------------------------------------|:-----|
| Name                                             | iris |
| Number of rows                                   | 150  |
| Number of columns                                | 5    |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |      |
| Column type frequency:                           |      |
| factor                                           | 1    |
| numeric                                          | 1    |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |      |
| Group variables                                  | None |

Table 2: Data summary

**Variable type: factor**

| skim\_variable | n\_missing | complete\_rate | ordered | n\_unique | top\_counts               |
|:---------------|-----------:|---------------:|:--------|----------:|:--------------------------|
| Species        |          0 |              1 | FALSE   |         3 | set: 50, ver: 50, vir: 50 |

**Variable type: numeric**

| skim\_variable | n\_missing | complete\_rate | mean |   sd |  p0 | p25 | p50 | p75 | p100 | hist  |
|:---------------|-----------:|---------------:|-----:|-----:|----:|----:|----:|----:|-----:|:------|
| Sepal.Width    |          0 |              1 | 3.06 | 0.44 |   2 | 2.8 |   3 | 3.3 |  4.4 | ▁▆▇▂▁ |

or with common `select()` helpers:

``` r
skim(iris, contains("Length"))
```

|                                                  |      |
|:-------------------------------------------------|:-----|
| Name                                             | iris |
| Number of rows                                   | 150  |
| Number of columns                                | 5    |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |      |
| Column type frequency:                           |      |
| numeric                                          | 2    |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |      |
| Group variables                                  | None |

Table 3: Data summary

**Variable type: numeric**

| skim\_variable | n\_missing | complete\_rate | mean |   sd |  p0 | p25 |  p50 | p75 | p100 | hist  |
|:---------------|-----------:|---------------:|-----:|-----:|----:|----:|-----:|----:|-----:|:------|
| Sepal.Length   |          0 |              1 | 5.84 | 0.83 | 4.3 | 5.1 | 5.80 | 6.4 |  7.9 | ▆▇▇▅▂ |
| Petal.Length   |          0 |              1 | 3.76 | 1.77 | 1.0 | 1.6 | 4.35 | 5.1 |  6.9 | ▇▁▆▇▂ |

We can also take the `summary()` of the skimmed data frame, and get the **Data Summary** part:

``` r
skim(iris) %>% 
  summary()
```

|                                                  |      |
|:-------------------------------------------------|:-----|
| Name                                             | iris |
| Number of rows                                   | 150  |
| Number of columns                                | 5    |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |      |
| Column type frequency:                           |      |
| factor                                           | 1    |
| numeric                                          | 4    |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |      |
| Group variables                                  | None |

Table 4: Data summary

`skim()` also supports grouped data created by `dplyr::group_by()`(and later we will see that `skim()` workes seamlessly in a typical **tidyverse**([Wickham et al. 2019](#ref-tidyverse2019)) workflow). In the grouped case, one additional column for each grouping variable is added.

``` r
iris %>%
  group_by(Species) %>%
  skim()
```

|                                                  |            |
|:-------------------------------------------------|:-----------|
| Name                                             | Piped data |
| Number of rows                                   | 150        |
| Number of columns                                | 5          |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |            |
| Column type frequency:                           |            |
| numeric                                          | 4          |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |            |
| Group variables                                  | Species    |

Table 5: Data summary

**Variable type: numeric**

| skim\_variable | Species    | n\_missing | complete\_rate | mean |   sd |  p0 |  p25 |  p50 |  p75 | p100 | hist  |
|:---------------|:-----------|-----------:|---------------:|-----:|-----:|----:|-----:|-----:|-----:|-----:|:------|
| Sepal.Length   | setosa     |          0 |              1 | 5.01 | 0.35 | 4.3 | 4.80 | 5.00 | 5.20 |  5.8 | ▃▃▇▅▁ |
| Sepal.Length   | versicolor |          0 |              1 | 5.94 | 0.52 | 4.9 | 5.60 | 5.90 | 6.30 |  7.0 | ▂▇▆▃▃ |
| Sepal.Length   | virginica  |          0 |              1 | 6.59 | 0.64 | 4.9 | 6.23 | 6.50 | 6.90 |  7.9 | ▁▃▇▃▂ |
| Sepal.Width    | setosa     |          0 |              1 | 3.43 | 0.38 | 2.3 | 3.20 | 3.40 | 3.68 |  4.4 | ▁▃▇▅▂ |
| Sepal.Width    | versicolor |          0 |              1 | 2.77 | 0.31 | 2.0 | 2.52 | 2.80 | 3.00 |  3.4 | ▁▅▆▇▂ |
| Sepal.Width    | virginica  |          0 |              1 | 2.97 | 0.32 | 2.2 | 2.80 | 3.00 | 3.18 |  3.8 | ▂▆▇▅▁ |
| Petal.Length   | setosa     |          0 |              1 | 1.46 | 0.17 | 1.0 | 1.40 | 1.50 | 1.58 |  1.9 | ▁▃▇▃▁ |
| Petal.Length   | versicolor |          0 |              1 | 4.26 | 0.47 | 3.0 | 4.00 | 4.35 | 4.60 |  5.1 | ▂▂▇▇▆ |
| Petal.Length   | virginica  |          0 |              1 | 5.55 | 0.55 | 4.5 | 5.10 | 5.55 | 5.88 |  6.9 | ▃▇▇▃▂ |
| Petal.Width    | setosa     |          0 |              1 | 0.25 | 0.11 | 0.1 | 0.20 | 0.20 | 0.30 |  0.6 | ▇▂▂▁▁ |
| Petal.Width    | versicolor |          0 |              1 | 1.33 | 0.20 | 1.0 | 1.20 | 1.30 | 1.50 |  1.8 | ▅▇▃▆▁ |
| Petal.Width    | virginica  |          0 |              1 | 2.03 | 0.27 | 1.4 | 1.80 | 2.00 | 2.30 |  2.5 | ▂▇▆▅▇ |

To better illustrate `skim()`, we should know it returns a `skim_df` object, which is essentially **a single wide data frame** combining the results, with some additional attributes and two metadata columns:

-   skim\_type: class of the variable
-   skim\_variable: name of the original variable

`is_skim_df()` function is used to assert that an object is a skim\_df.

``` r
class(skim(iris))
#> [1] "skim_df"    "tbl_df"     "tbl"        "data.frame"
is_skim_df(skim(iris))
#> [1] TRUE
#> attr(,"message")
#> character(0)
```

To explicitly show 2 columns `skim_type` and `skim_variable` and see the nature of this `skim_df` object, we can transfrom it to a `tibble` or `data.frame`

``` r
iris %>% 
  skim() %>% 
  as_tibble()
#> # A tibble: 5 x 15
#>   skim_type skim_variable n_missing complete_rate factor.ordered factor.n_unique
#>   <chr>     <chr>             <int>         <dbl> <lgl>                    <int>
#> 1 factor    Species               0             1 FALSE                        3
#> 2 numeric   Sepal.Length          0             1 NA                          NA
#> 3 numeric   Sepal.Width           0             1 NA                          NA
#> 4 numeric   Petal.Length          0             1 NA                          NA
#> 5 numeric   Petal.Width           0             1 NA                          NA
#> # ... with 9 more variables: factor.top_counts <chr>, numeric.mean <dbl>,
#> #   numeric.sd <dbl>, numeric.p0 <dbl>, numeric.p25 <dbl>, numeric.p50 <dbl>,
#> #   numeric.p75 <dbl>, numeric.p100 <dbl>, numeric.hist <chr>
```

As you can see, the **Data Summary** part are excluded after the transformation, and the wide data frame are left. This is in contrast to `summary.data.frame()`, which stores statistics in a table. The distinction is important, **because the `skim_df object` is pipeable and easy to use for additional manipulation**: for example, the user could select all of the `variable` means, or all summary statistics for a specific variable (Note that we don’t have to really transform it before such manipulation).

Filtering by column types:

``` r
skim(iris) %>% 
  filter(skim_type == "numeric")
```

|                                                  |      |
|:-------------------------------------------------|:-----|
| Name                                             | iris |
| Number of rows                                   | 150  |
| Number of columns                                | 5    |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |      |
| Column type frequency:                           |      |
| numeric                                          | 4    |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |      |
| Group variables                                  | None |

Table 6: Data summary

**Variable type: numeric**

| skim\_variable | n\_missing | complete\_rate | mean |   sd |  p0 | p25 |  p50 | p75 | p100 | hist  |
|:---------------|-----------:|---------------:|-----:|-----:|----:|----:|-----:|----:|-----:|:------|
| Sepal.Length   |          0 |              1 | 5.84 | 0.83 | 4.3 | 5.1 | 5.80 | 6.4 |  7.9 | ▆▇▇▅▂ |
| Sepal.Width    |          0 |              1 | 3.06 | 0.44 | 2.0 | 2.8 | 3.00 | 3.3 |  4.4 | ▁▆▇▂▁ |
| Petal.Length   |          0 |              1 | 3.76 | 1.77 | 1.0 | 1.6 | 4.35 | 5.1 |  6.9 | ▇▁▆▇▂ |
| Petal.Width    |          0 |              1 | 1.20 | 0.76 | 0.1 | 0.3 | 1.30 | 1.8 |  2.5 | ▇▁▇▅▃ |

``` r
skim(iris) %>% 
  filter(skim_variable == "Sepal.Length")
```

|                                                  |      |
|:-------------------------------------------------|:-----|
| Name                                             | iris |
| Number of rows                                   | 150  |
| Number of columns                                | 5    |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |      |
| Column type frequency:                           |      |
| numeric                                          | 1    |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |      |
| Group variables                                  | None |

Table 7: Data summary

**Variable type: numeric**

| skim\_variable | n\_missing | complete\_rate | mean |   sd |  p0 | p25 | p50 | p75 | p100 | hist  |
|:---------------|-----------:|---------------:|-----:|-----:|----:|----:|----:|----:|-----:|:------|
| Sepal.Length   |          0 |              1 | 5.84 | 0.83 | 4.3 | 5.1 | 5.8 | 6.4 |  7.9 | ▆▇▇▅▂ |

When using `select()` to choose statistics we want to display, `n_missing` and `complete_rate` can be directly specified, since they are computed for all types of columns. Other statistics must be specified in `select` with a prefix, as shown in the column names of `skim(iris) %>% as_tibble()` (i.e, extracting the arithmet mean by `numeric.mean`):

``` r
# no need to put a prefix
skim(iris) %>% 
  select(skim_variable, skim_type, n_missing, complete_rate)
```

|                                                  |      |
|:-------------------------------------------------|:-----|
| Name                                             | iris |
| Number of rows                                   | 150  |
| Number of columns                                | 5    |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |      |
| Column type frequency:                           |      |
| factor                                           | 1    |
| numeric                                          | 4    |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |      |
| Group variables                                  | None |

Table 8: Data summary

**Variable type: factor**

| skim\_variable | n\_missing | complete\_rate |
|:---------------|-----------:|---------------:|
| Species        |          0 |              1 |

**Variable type: numeric**

| skim\_variable | n\_missing | complete\_rate |
|:---------------|-----------:|---------------:|
| Sepal.Length   |          0 |              1 |
| Sepal.Width    |          0 |              1 |
| Petal.Length   |          0 |              1 |
| Petal.Width    |          0 |              1 |

``` r
# extract the mean and median with a prefix
skim(iris) %>% 
  filter(skim_type == "numeric") %>%
  select(skim_variable, numeric.mean, numeric.p50)
#> # A tibble: 4 x 3
#>   skim_variable numeric.mean numeric.p50
#>   <chr>                <dbl>       <dbl>
#> 1 Sepal.Length          5.84        5.8 
#> 2 Sepal.Width           3.06        3   
#> 3 Petal.Length          3.76        4.35
#> 4 Petal.Width           1.20        1.3
# extract top levels of a factor
skim(iris) %>% 
  filter(skim_type == "factor") %>% 
  select(skim_variable, factor.top_counts)
#> # A tibble: 1 x 2
#>   skim_variable factor.top_counts        
#>   <chr>         <chr>                    
#> 1 Species       set: 50, ver: 50, vir: 50
```

Or we can combine `select_if()` with `skim()`

``` r
iris %>% 
  select_if(is.numeric) %>% 
  skim()
```

|                                                  |            |
|:-------------------------------------------------|:-----------|
| Name                                             | Piped data |
| Number of rows                                   | 150        |
| Number of columns                                | 4          |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |            |
| Column type frequency:                           |            |
| numeric                                          | 4          |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |            |
| Group variables                                  | None       |

Table 9: Data summary

**Variable type: numeric**

| skim\_variable | n\_missing | complete\_rate | mean |   sd |  p0 | p25 |  p50 | p75 | p100 | hist  |
|:---------------|-----------:|---------------:|-----:|-----:|----:|----:|-----:|----:|-----:|:------|
| Sepal.Length   |          0 |              1 | 5.84 | 0.83 | 4.3 | 5.1 | 5.80 | 6.4 |  7.9 | ▆▇▇▅▂ |
| Sepal.Width    |          0 |              1 | 3.06 | 0.44 | 2.0 | 2.8 | 3.00 | 3.3 |  4.4 | ▁▆▇▂▁ |
| Petal.Length   |          0 |              1 | 3.76 | 1.77 | 1.0 | 1.6 | 4.35 | 5.1 |  6.9 | ▇▁▆▇▂ |
| Petal.Width    |          0 |              1 | 1.20 | 0.76 | 0.1 | 0.3 | 1.30 | 1.8 |  2.5 | ▇▁▇▅▃ |

Finally, just for fun, what statistics or which variable we choose to use will not affect the `skim_df` variable type, yet this is not the case for `skim_variable` and `skim_type`, which are intrinsic to `skim_df` objects. If we exclude these two, the `skim_df` object will be automatically coerced to a tibble:

``` r
skim(iris) %>% 
  select(-skim_type, -skim_variable) %>%
  is_skim_df()
#> [1] FALSE
#> attr(,"message")
#> [1] "Object is not a `skim_df`: missing column `skim_type`; missing column `skim_variable`"
```

# Manipulating the results

As noted above, `skim()` returns a wide data frame, an `skim_df` object. This is usually the most sensible format for the majority of operations when investigating data, and **skimr** also provides functions aimed at facilitating the exploratory process .

First, `partition()` returns a named list of the wide data frames **for each data type**. Unlike the original data the partitioned data only has columns corresponding to the skimming functions use for this data type. These data frames are, therefore, not `skim_df` objects. And we can easily subset that list to get desirable component:

``` r
iris %>%
  skim() %>%
  partition()
```

**Variable type: factor**

| skim\_variable | n\_missing | complete\_rate | ordered | n\_unique | top\_counts               |
|:---------------|-----------:|---------------:|:--------|----------:|:--------------------------|
| Species        |          0 |              1 | FALSE   |         3 | set: 50, ver: 50, vir: 50 |

**Variable type: numeric**

| skim\_variable | n\_missing | complete\_rate | mean |   sd |  p0 | p25 |  p50 | p75 | p100 | hist  |
|:---------------|-----------:|---------------:|-----:|-----:|----:|----:|-----:|----:|-----:|:------|
| Sepal.Length   |          0 |              1 | 5.84 | 0.83 | 4.3 | 5.1 | 5.80 | 6.4 |  7.9 | ▆▇▇▅▂ |
| Sepal.Width    |          0 |              1 | 3.06 | 0.44 | 2.0 | 2.8 | 3.00 | 3.3 |  4.4 | ▁▆▇▂▁ |
| Petal.Length   |          0 |              1 | 3.76 | 1.77 | 1.0 | 1.6 | 4.35 | 5.1 |  6.9 | ▇▁▆▇▂ |
| Petal.Width    |          0 |              1 | 1.20 | 0.76 | 0.1 | 0.3 | 1.30 | 1.8 |  2.5 | ▇▁▇▅▃ |

Each component of the resulting list is an `one_skim_df` object, and can be readily coerced to tibbles:

``` r
iris %>%
  skim() %>%
  partition() %>%
  map(class)
#> $factor
#> [1] "one_skim_df" "tbl_df"      "tbl"         "data.frame" 
#> 
#> $numeric
#> [1] "one_skim_df" "tbl_df"      "tbl"         "data.frame"
```

This is useful when we only want to look at certain data types, we can subset that component out of the partitioned result, coerce it to a tibble, and then manipulate it. We don’t have to put a prefix before column names now, since rows in every component are of identical data types, and therefore share same statistics:

``` r
# subset
iris_numeric <- iris %>%
  skim() %>% 
  partition() %>%
  pluck("numeric") %>%
  as_tibble()

iris_numeric %>% 
  arrange(sd)  ## no more numeric.sd
#> # A tibble: 4 x 11
#>   skim_variable n_missing complete_rate  mean    sd    p0   p25   p50   p75
#>   <chr>             <int>         <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 Sepal.Width           0             1  3.06 0.436   2     2.8  3      3.3
#> 2 Petal.Width           0             1  1.20 0.762   0.1   0.3  1.3    1.8
#> 3 Sepal.Length          0             1  5.84 0.828   4.3   5.1  5.8    6.4
#> 4 Petal.Length          0             1  3.76 1.77    1     1.6  4.35   5.1
#> # ... with 2 more variables: p100 <dbl>, hist <chr>
```

Second, `yank()` selects only specified variables base on their type, this can be viewed as a shortcut to `partition()` and subsetting:

``` r
iris %>% 
  skim() %>% 
  yank("factor")
```

**Variable type: factor**

| skim\_variable | n\_missing | complete\_rate | ordered | n\_unique | top\_counts               |
|:---------------|-----------:|---------------:|:--------|----------:|:--------------------------|
| Species        |          0 |              1 | FALSE   |         3 | set: 50, ver: 50, vir: 50 |

Use `focus()` to select columns of the skimmed results and keep them as a `skim_df`; it always keeps the metadata column. In other words, to **focus** on some statistics:

``` r
iris %>% 
  skim() %>%
  focus(n_missing, numeric.mean)
```

|                                                  |            |
|:-------------------------------------------------|:-----------|
| Name                                             | Piped data |
| Number of rows                                   | 150        |
| Number of columns                                | 5          |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |            |
| Column type frequency:                           |            |
| factor                                           | 1          |
| numeric                                          | 4          |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |            |
| Group variables                                  | None       |

Table 10: Data summary

**Variable type: factor**

| skim\_variable | n\_missing |
|:---------------|-----------:|
| Species        |          0 |

**Variable type: numeric**

| skim\_variable | n\_missing | mean |
|:---------------|-----------:|-----:|
| Sepal.Length   |          0 | 5.84 |
| Sepal.Width    |          0 | 3.06 |
| Petal.Length   |          0 | 3.76 |
| Petal.Width    |          0 | 1.20 |

# Customizing `skim()`

We can create out own skimming function with the `skim_with()` function factory. To add a statistic for a data type, create an `sfl()` (a skimr function list) for each class that you want to change:

``` r
# also look at skewness and kurtosis for numerical variables
library(e1071)
my_skim <- skim_with(numeric = sfl("3rd_central_moment" = skewness,
                                   "4th_central_moment" = kurtosis))
```

Now, we can use `my_skim` to skim through numerical variables:

``` r
my_skim(iris) %>% 
  yank("numeric")
```

**Variable type: numeric**

| skim\_variable | n\_missing | complete\_rate | mean |   sd |  p0 | p25 |  p50 | p75 | p100 | hist  | 3rd\_central\_moment | 4th\_central\_moment |
|:---------------|-----------:|---------------:|-----:|-----:|----:|----:|-----:|----:|-----:|:------|---------------------:|---------------------:|
| Sepal.Length   |          0 |              1 | 5.84 | 0.83 | 4.3 | 5.1 | 5.80 | 6.4 |  7.9 | ▆▇▇▅▂ |                 0.31 |                -0.61 |
| Sepal.Width    |          0 |              1 | 3.06 | 0.44 | 2.0 | 2.8 | 3.00 | 3.3 |  4.4 | ▁▆▇▂▁ |                 0.31 |                 0.14 |
| Petal.Length   |          0 |              1 | 3.76 | 1.77 | 1.0 | 1.6 | 4.35 | 5.1 |  6.9 | ▇▁▆▇▂ |                -0.27 |                -1.42 |
| Petal.Width    |          0 |              1 | 1.20 | 0.76 | 0.1 | 0.3 | 1.30 | 1.8 |  2.5 | ▇▁▇▅▃ |                -0.10 |                -1.36 |

When using `skim_with()`, the named list in `sf1()` correspond to statistics calculated on a specified type, so names of that list must fall into one of R’s classes, available classes are (see `?get_skimmers`):

-   numeric
-   character  
-   factor  
-   logical  
-   complex  
-   Date  
-   POSIXct  
-   difftime  
-   ts  
-   AsIs

It you want to customize `skim()` to support more data classes, [here](https://docs.ropensci.org/skimr/articles/Supporting_additional_objects.html#conclusion) is an simple example, adding support for `sf` oject.

# Skimming non-data frames

In **skimr** [v2](https://github.com/ropensci/skimr/releases), `skim()` will attempt to coerce non-data frames (such as vectors and matrices) to data frames. In most cases with vectors, the object being evaluated should be equivalent to wrapping the object in as.data.frame().

Skimming charactor vector:

``` r
skim(letters)
```

|                                                  |         |
|:-------------------------------------------------|:--------|
| Name                                             | letters |
| Number of rows                                   | 26      |
| Number of columns                                | 1       |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |         |
| Column type frequency:                           |         |
| character                                        | 1       |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |         |
| Group variables                                  | None    |

Table 11: Data summary

**Variable type: character**

| skim\_variable | n\_missing | complete\_rate | min | max | empty | n\_unique | whitespace |
|:---------------|-----------:|---------------:|----:|----:|------:|----------:|-----------:|
| data           |          0 |              1 |   1 |   1 |     0 |        26 |          0 |

This is same to:

``` r
skim(as.data.frame(letters))
```

|                                                  |                        |
|:-------------------------------------------------|:-----------------------|
| Name                                             | as.data.frame(letters) |
| Number of rows                                   | 26                     |
| Number of columns                                | 1                      |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |                        |
| Column type frequency:                           |                        |
| character                                        | 1                      |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |                        |
| Group variables                                  | None                   |

Table 12: Data summary

**Variable type: character**

| skim\_variable | n\_missing | complete\_rate | min | max | empty | n\_unique | whitespace |
|:---------------|-----------:|---------------:|----:|----:|------:|----------:|-----------:|
| letters        |          0 |              1 |   1 |   1 |     0 |        26 |          0 |

The way `skim()` works with `list` is some natural, for data frames are just a special case of list:

``` r
my_list <- list(a = 1:10, b = letters[1:10], c = factor(1:10))
skim(my_list)
```

|                                                  |          |
|:-------------------------------------------------|:---------|
| Name                                             | my\_list |
| Number of rows                                   | 10       |
| Number of columns                                | 3        |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |          |
| Column type frequency:                           |          |
| character                                        | 1        |
| factor                                           | 1        |
| numeric                                          | 1        |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |          |
| Group variables                                  | None     |

Table 13: Data summary

**Variable type: character**

| skim\_variable | n\_missing | complete\_rate | min | max | empty | n\_unique | whitespace |
|:---------------|-----------:|---------------:|----:|----:|------:|----------:|-----------:|
| b              |          0 |              1 |   1 |   1 |     0 |        10 |          0 |

**Variable type: factor**

| skim\_variable | n\_missing | complete\_rate | ordered | n\_unique | top\_counts            |
|:---------------|-----------:|---------------:|:--------|----------:|:-----------------------|
| c              |          0 |              1 | FALSE   |        10 | 1: 1, 2: 1, 3: 1, 4: 1 |

**Variable type: numeric**

| skim\_variable | n\_missing | complete\_rate | mean |   sd |  p0 |  p25 | p50 |  p75 | p100 | hist  |
|:---------------|-----------:|---------------:|-----:|-----:|----:|-----:|----:|-----:|-----:|:------|
| a              |          0 |              1 |  5.5 | 3.03 |   1 | 3.25 | 5.5 | 7.75 |   10 | ▇▇▇▇▇ |

skimming `ts` object:

``` r
lynx
#> Time Series:
#> Start = 1821 
#> End = 1934 
#> Frequency = 1 
#>   [1]  269  321  585  871 1475 2821 3928 5943 4950 2577  523   98  184  279  409
#>  [16] 2285 2685 3409 1824  409  151   45   68  213  546 1033 2129 2536  957  361
#>  [31]  377  225  360  731 1638 2725 2871 2119  684  299  236  245  552 1623 3311
#>  [46] 6721 4254  687  255  473  358  784 1594 1676 2251 1426  756  299  201  229
#>  [61]  469  736 2042 2811 4431 2511  389   73   39   49   59  188  377 1292 4031
#>  [76] 3495  587  105  153  387  758 1307 3465 6991 6313 3794 1836  345  382  808
#>  [91] 1388 2713 3800 3091 2985 3790  674   81   80  108  229  399 1132 2432 3574
#> [106] 2935 1537  529  485  662 1000 1590 2657 3396
# note the last inline line graph, pretty cute
skim(lynx)
```

|                                                  |      |
|:-------------------------------------------------|:-----|
| Name                                             | lynx |
| Number of rows                                   | 114  |
| Number of columns                                | 1    |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |      |
| Column type frequency:                           |      |
| ts                                               | 1    |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |      |
| Group variables                                  | None |

Table 14: Data summary

**Variable type: ts**

| skim\_variable | n\_missing | complete\_rate | start |  end | frequency | deltat |    mean |      sd | min |  max | median | line\_graph |
|:---------------|-----------:|---------------:|------:|-----:|----------:|-------:|--------:|--------:|----:|-----:|-------:|:------------|
| x              |          0 |              1 |  1821 | 1934 |         1 |      1 | 1538.02 | 1585.84 |  39 | 6991 |    771 | ⡈⢄⡠⢁⣀⠒⣀⠔    |

when skimming matrices, columns and treated as variables and rows as observations, so statistics are calculated on a column basis:

``` r
m <- matrix(1:12, nrow = 4, ncol = 3)
m
#>      [,1] [,2] [,3]
#> [1,]    1    5    9
#> [2,]    2    6   10
#> [3,]    3    7   11
#> [4,]    4    8   12
```

``` r
skim(m)
```

|                                                  |      |
|:-------------------------------------------------|:-----|
| Name                                             | m    |
| Number of rows                                   | 4    |
| Number of columns                                | 3    |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |      |
| Column type frequency:                           |      |
| numeric                                          | 3    |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |      |
| Group variables                                  | None |

Table 15: Data summary

**Variable type: numeric**

| skim\_variable | n\_missing | complete\_rate | mean |   sd |  p0 |  p25 |  p50 |   p75 | p100 | hist  |
|:---------------|-----------:|---------------:|-----:|-----:|----:|-----:|-----:|------:|-----:|:------|
| V1             |          0 |              1 |  2.5 | 1.29 |   1 | 1.75 |  2.5 |  3.25 |    4 | ▇▇▁▇▇ |
| V2             |          0 |              1 |  6.5 | 1.29 |   5 | 5.75 |  6.5 |  7.25 |    8 | ▇▇▁▇▇ |
| V3             |          0 |              1 | 10.5 | 1.29 |   9 | 9.75 | 10.5 | 11.25 |   12 | ▇▇▁▇▇ |

Transpose the matrix:

``` r
skim(t(m))
```

|                                                  |      |
|:-------------------------------------------------|:-----|
| Name                                             | t(m) |
| Number of rows                                   | 3    |
| Number of columns                                | 4    |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_   |      |
| Column type frequency:                           |      |
| numeric                                          | 4    |
| \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ |      |
| Group variables                                  | None |

Table 16: Data summary

**Variable type: numeric**

| skim\_variable | n\_missing | complete\_rate | mean |  sd |  p0 | p25 | p50 | p75 | p100 | hist  |
|:---------------|-----------:|---------------:|-----:|----:|----:|----:|----:|----:|-----:|:------|
| V1             |          0 |              1 |    5 |   4 |   1 |   3 |   5 |   7 |    9 | ▇▁▇▁▇ |
| V2             |          0 |              1 |    6 |   4 |   2 |   4 |   6 |   8 |   10 | ▇▁▇▁▇ |
| V3             |          0 |              1 |    7 |   4 |   3 |   5 |   7 |   9 |   11 | ▇▁▇▁▇ |
| V4             |          0 |              1 |    8 |   4 |   4 |   6 |   8 |  10 |   12 | ▇▁▇▁▇ |

# References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-R-skimr" class="csl-entry">

Waring, Elin, Michael Quinn, Amelia McNamara, Eduardo Arino de la Rubia, Hao Zhu, and Shannon Ellis. 2019. *Skimr: Compact and Flexible Summaries of Data*. <https://CRAN.R-project.org/package=skimr>.

</div>

<div id="ref-tidyverse2019" class="csl-entry">

Wickham, Hadley, Mara Averick, Jennifer Bryan, Winston Chang, Lucy D’Agostino McGowan, Romain François, Garrett Grolemund, et al. 2019. “Welcome to the <span class="nocase">tidyverse</span>.” *Journal of Open Source Software* 4 (43): 1686. <https://doi.org/10.21105/joss.01686>.

</div>

</div>

[^1]: In the sense that `skim()` provides useful, tidy summary statistics and displays it in a pretty form for exploratory analysis based on data frames. `skim()` cannot supplant `summary()` in terms of model interpretation, viewing geospatial objects, etc.
