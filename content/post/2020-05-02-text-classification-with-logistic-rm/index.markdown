---
title: Text Classfication with Penalized Logistic Regression
author: Qiushi Yan
date: '2020-05-02'
slug: text-classification-logistic
categories: ["Data Analysis", "Machine Learning", "R"]
summary: 'Teach models how to distinguish Charlotte Brontë from Emily Brontë'
lastmod: '2020-05-02T23:33:49+08:00'
bibliography: ../bib/text-classification.bib
biblio-style: apalike
link-citations: yes
image:
  caption: ''
  focal_point: ''
  preview_only: yes
---

In this post I aim to train a text classification model with penalized logistic regression using the [`tidymodels`](https://www.tidymodels.org/) framework. Data are from 5 books and downloaded via the [`gutenbergr`](https://docs.ropensci.org/gutenbergr/) package, written by either Emily Brontë or Charlotte Brontë. And the goal is to predict the author of a line, in other words the probability of line being written by one sister instead of another.

``` r
library(tidyverse)
library(tidytext)
library(gutenbergr)
```

``` r
books <- gutenberg_works() %>% 
  filter(str_detect(author, "Brontë, Emily|Brontë, Charlotte")) %>% 
  gutenberg_download(meta_fields = c("title", "author")) %>% 
  transmute(title,
            author = if_else(author == "Brontë, Emily", 
                             "Emily Brontë", 
                             "Charlotte Brontë") %>% factor(),
            line_index = row_number(),
            text)
```

`books` is at line level

``` r
books
#> # A tibble: 88,989 x 4
#>    title             author       line_index text                               
#>    <chr>             <fct>             <int> <chr>                              
#>  1 Wuthering Heights Emily Brontë          1 "WUTHERING HEIGHTS"                
#>  2 Wuthering Heights Emily Brontë          2 ""                                 
#>  3 Wuthering Heights Emily Brontë          3 ""                                 
#>  4 Wuthering Heights Emily Brontë          4 "CHAPTER I"                        
#>  5 Wuthering Heights Emily Brontë          5 ""                                 
#>  6 Wuthering Heights Emily Brontë          6 ""                                 
#>  7 Wuthering Heights Emily Brontë          7 "1801.--I have just returned from ~
#>  8 Wuthering Heights Emily Brontë          8 "neighbour that I shall be trouble~
#>  9 Wuthering Heights Emily Brontë          9 "country!  In all England, I do no~
#> 10 Wuthering Heights Emily Brontë         10 "situation so completely removed f~
#> # ... with 88,979 more rows
```

To obtain tidy text structure illustrated in [Text Mining with R](https://www.tidytextmining.com/), I use `unnest_tokens()` to perform tokenization and remove all the stop words. I also removed characters like `'`, `'s`, `'` and whitespaces to return valid column names after widening. But it turns out this served as some sort of stemming too! (heathcliff’s becomes heathcliff). Then low frequency words (whose frequency is less than 0.05% of an author’s total word counts) are removed. The cutoff may be a little too high if you plot that histogram, but I really need this to save computation efforts on my laptop :sweat\_smile:.

``` r
clean_books <- books %>% 
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>% 
  filter(!str_detect(word, "^\\d+$")) %>% 
  mutate(word = str_remove_all(word, "_|'s|'|\\s"))
  
total_words <- clean_books %>%
  count(author, name = "total")

tidy_books <- clean_books %>%
  left_join(total_words) %>% 
  group_by(author, total, word) %>%
  filter((n() / total) > 0.0005) %>% 
  ungroup() 
```

# Comparing word frequency

Before building an actual predictive model, let’s do some EDA to see different tendency to use a particular word! This will also shed light on what we would expect from the text classification. Now, we will compare word frequency (proportion) between the two sisters.

``` r
tidy_books %>% 
  group_by(author, total) %>%
  count(word) %>% 
  mutate(prop = n / total) %>% 
  ungroup() %>% 
  select(-total, -n) %>%
  pivot_wider(names_from  = author, values_from = prop,
              values_fill = list(prop = 0)) %>% 
  ggplot(aes(x = `Charlotte Brontë`, y = `Emily Brontë`, 
             color = abs(`Emily Brontë` -  `Charlotte Brontë`))) + 
  geom_jitter(width = 0.001, height = 0.001, alpha = 0.2, size = 2.5) + 
  geom_abline(color = "gray40", lty = 2) + 
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5, size = 7.5) + 
  scale_color_gradient(low = "darkslategray4", high = "gray75") +
  scale_x_continuous(labels = scales::label_percent()) + 
  scale_y_continuous(labels = scales::label_percent()) +  
  theme(legend.position = "none") + 
  coord_cartesian(xlim = c(0, NA)) + 
  labs(title = "Word frequency between two sisters") + 
  theme(text = element_text(size = 18),
        plot.title.position = "plot")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-8-1.png" width="1440" />

Words lie near the line such as “home,” “head” and “half” indicate similar tendency to use that word, while those that are far from the line are words that are found more in one set of texts than another, for example “headthcliff,” “linton,” “catherine,” etc.

What does this plot tell us? Judged only by word frequency, it looks that there are a number of words that are quite characteristic of Emily Brontë (upper left corner). Charlotte, on the other hand, has few representative words (bottom right corner). We will investigate this further in the model.

# Modeling

## Data preprocessing

There are 423 and features (words) and 47119 observations in total. Approximately 18% of the response are 1 (Emily Brontë).

``` r
tidy_books %>% 
  count(author) %>% 
  mutate(prop = n / sum(n))
#> # A tibble: 2 x 3
#>   author               n  prop
#>   <fct>            <int> <dbl>
#> 1 Charlotte Brontë 64858 0.817
#> 2 Emily Brontë     14489 0.183
```

Now it’s time to widen our data to reach an appropriate model structure, this similar to a document-term matrix, with rows being a line and column word count.

``` r
library(tidymodels)
set.seed(2020)
doParallel::registerDoParallel()

model_df <- tidy_books %>% 
  count(line_index, word) %>% 
  pivot_wider(names_from = word, values_from = n,
              values_fill = list(n = 0)) %>% 
  left_join(books, by = c("line_index" = "line_index")) %>% 
  select(-title, -text)

model_df
#> # A tibble: 47,119 x 425
#>    line_index heights wuthering chapter returned visit heathcliff heaven black
#>         <int>   <int>     <int>   <int>    <int> <int>      <int>  <int> <int>
#>  1          1       1         1       0        0     0          0      0     0
#>  2          4       0         0       1        0     0          0      0     0
#>  3          7       0         0       0        1     1          0      0     0
#>  4         11       0         0       0        0     0          1      1     0
#>  5         13       0         0       0        0     0          0      0     1
#>  6         15       0         0       0        0     0          0      0     0
#>  7         18       0         0       0        0     0          1      0     0
#>  8         20       0         0       0        0     0          0      0     0
#>  9         22       0         0       0        0     0          0      0     0
#> 10         23       0         0       0        0     0          0      0     0
#> # ... with 47,109 more rows, and 416 more variables: eyes <int>, heart <int>,
#> #   fingers <int>, answer <int>, sir <int>, hope <int>, grange <int>,
#> #   heard <int>, thrushcross <int>, interrupted <int>, walk <int>,
#> #   closed <int>, uttered <int>, gate <int>, words <int>, horse <int>,
#> #   hand <int>, entered <int>, joseph <int>, bring <int>, suppose <int>,
#> #   nay <int>, dinner <int>, guess <int>, times <int>, wind <int>, house <int>,
#> #   strong <int>, set <int>, wall <int>, door <int>, earnshaw <int>, ...
```

## Train a penalized logistic regression model

Split the data into training set and testing set.

``` r
book_split <- initial_split(model_df)
book_train <- training(book_split)
book_test <- testing(book_split)
```

Specify a L1 penalized logistic model, center and scale all predictors and combine them in to a `workflow` object.

``` r
logistic_spec <- logistic_reg(penalty = 0.05, mixture = 1) %>%
  set_engine("glmnet")

book_rec <- recipe(author ~ ., data = book_train) %>% 
  update_role(line_index, new_role = "ID") %>% 
  step_zv(all_predictors()) %>% 
  step_normalize(all_predictors())

book_wf <- workflow() %>% 
  add_model(logistic_spec) %>% 
  add_recipe(book_rec)

initial_fit <- book_wf %>% 
  fit(data = book_train)
```

`initial_fit` is a simple fitted regression model without any hyperparameters. By default `glmnet` calls for 100 values of lambda even if I specify `\(\lambda = 0.05\)`. So the extracted result aren’t that helpful.

``` r
initial_fit %>%
  pull_workflow_fit() %>% 
  tidy()
#> # A tibble: 424 x 3
#>    term        estimate penalty
#>    <chr>          <dbl>   <dbl>
#>  1 (Intercept)   -1.66     0.05
#>  2 heights        0        0.05
#>  3 wuthering      0        0.05
#>  4 chapter        0        0.05
#>  5 returned       0        0.05
#>  6 visit          0        0.05
#>  7 heathcliff     0.166    0.05
#>  8 heaven         0        0.05
#>  9 black          0        0.05
#> 10 eyes           0        0.05
#> # ... with 414 more rows
```

We can make predictions with `initial_fit` anyway, and examine metrics like overall accuracy.

``` r
initial_predict <- predict(initial_fit, book_test) %>% 
    bind_cols(predict(initial_fit, book_test, type = "prob")) %>%
    bind_cols(book_test %>% select(author, line_index))

initial_predict
#> # A tibble: 11,780 x 5
#>    .pred_class      `.pred_Charlotte Br~ `.pred_Emily Bron~ author    line_index
#>    <fct>                           <dbl>              <dbl> <fct>          <int>
#>  1 Charlotte Brontë                0.846              0.154 Emily Br~          7
#>  2 Charlotte Brontë                0.516              0.484 Emily Br~         11
#>  3 Charlotte Brontë                0.846              0.154 Emily Br~         15
#>  4 Charlotte Brontë                0.846              0.154 Emily Br~         27
#>  5 Charlotte Brontë                0.846              0.154 Emily Br~         38
#>  6 Charlotte Brontë                0.516              0.484 Emily Br~         52
#>  7 Charlotte Brontë                0.846              0.154 Emily Br~         55
#>  8 Charlotte Brontë                0.846              0.154 Emily Br~         59
#>  9 Charlotte Brontë                0.846              0.154 Emily Br~         80
#> 10 Charlotte Brontë                0.846              0.154 Emily Br~         83
#> # ... with 11,770 more rows
```

How good is our initial model?

``` r
initial_predict %>% 
  accuracy(truth = author, estimate = .pred_class)
#> # A tibble: 1 x 3
#>   .metric  .estimator .estimate
#>   <chr>    <chr>          <dbl>
#> 1 accuracy binary         0.839
```

Nearly 84% of all predictions are right. This isn’t a very statisfactory result since “Charlotte Brontë” accounts for 81% of `author`, making our model only slightly better than a classifier that would assngin all `author` with “Charlotte Brontë” anyway.

### Tuning lambda

We can figure out an appropriate penalty using resampling and tune the model.

``` r
logistic_wf_tune <- book_wf %>%
  update_model(logistic_spec %>% set_args(penalty = tune()))

lambda_grid <- grid_regular(penalty(), levels = 100)
book_folds <- vfold_cv(book_train, v = 10)
```

Here I build a set of 10 cross validations resamples, and set `levels = 100` to try 100 choices of lambda ranging from 0 to 1.

Then I tune the grid:

``` r
logistic_results <- logistic_wf_tune %>%    
  tune_grid(
    resamples = book_folds,
    grid = lambda_grid)
```

There is an `autoplot()` method for the tuned results, but I instead plot two metrics versus lambda respectivcely by myself.

``` r
logistic_results %>% 
  collect_metrics() %>% 
  mutate(lower_bound = mean - std_err,
         upper_bound = mean + std_err) %>%
  ggplot(aes(penalty, mean)) + 
  geom_line(aes(color = .metric), size = 1.5, show.legend = FALSE) + 
  geom_errorbar(aes(ymin = lower_bound, ymax = upper_bound)) + 
  facet_wrap(~ .metric, nrow = 2, scales = "free") + 
  labs(y = NULL,
       x = expression(lambda),
       title = "Performance metric of logistic regession versus differenct choices of L1 regularization")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-18-1.png" width="960" />

Ok, the two metrics both display a monotone decrease as lambda increases, but does not exhibit much change once lambda is greater than 0.1, which is essentailly random guess according to the author’s respective proportion of appearance in the data. This plot shows that the model is generally better at small penalty, suggesting that the majority of the predictors are fairly important to the model. We may lean towards larger penalty with slightly worse performance, bacause they lead to simpler models. It follows that we may want to choose lambda in top rows in the following data frame

``` r
top_models <- logistic_results %>% 
    show_best("roc_auc", n = 100) %>%
    arrange(desc(penalty)) %>% 
    filter(mean > 0.9)

top_models
#> # A tibble: 76 x 7
#>     penalty .metric .estimator  mean     n std_err .config               
#>       <dbl> <chr>   <chr>      <dbl> <int>   <dbl> <chr>                 
#>  1 0.00376  roc_auc binary     0.904    10 0.00268 Preprocessor1_Model076
#>  2 0.00298  roc_auc binary     0.907    10 0.00264 Preprocessor1_Model075
#>  3 0.00236  roc_auc binary     0.909    10 0.00280 Preprocessor1_Model074
#>  4 0.00187  roc_auc binary     0.911    10 0.00275 Preprocessor1_Model073
#>  5 0.00148  roc_auc binary     0.911    10 0.00277 Preprocessor1_Model072
#>  6 0.00118  roc_auc binary     0.911    10 0.00270 Preprocessor1_Model071
#>  7 0.000933 roc_auc binary     0.911    10 0.00271 Preprocessor1_Model070
#>  8 0.000739 roc_auc binary     0.911    10 0.00266 Preprocessor1_Model069
#>  9 0.000586 roc_auc binary     0.911    10 0.00259 Preprocessor1_Model068
#> 10 0.000464 roc_auc binary     0.911    10 0.00256 Preprocessor1_Model067
#> # ... with 66 more rows
```

`select_best()` with return the 9th row with `\(\lambda \approx 0.000586\)` for its highest performance on `roc_auc`. But I’ll stick to the parsimonious principle and pick `\(\lambda \approx 0.00376\)` at the cost of a fall in `roc_auc` by 0.005 and in `accuracy` by 0.001.

``` r
logistic_results %>% 
  select_best(metric = "roc_auc")
#> # A tibble: 1 x 2
#>   penalty .config               
#>     <dbl> <chr>                 
#> 1 0.00148 Preprocessor1_Model072

book_wf_final <- finalize_workflow(logistic_wf_tune,
                                  parameters = top_models %>% slice(1))
```

Now the model specification in the workflow is filled with the picked lambda:

``` r
book_wf_final %>% pull_workflow_spec()
#> Logistic Regression Model Specification (classification)
#> 
#> Main Arguments:
#>   penalty = 0.00376493580679246
#>   mixture = 1
#> 
#> Computational engine: glmnet
```

The next thing is to fit the best model with the training set, and evaluate against the test set.

``` r
logistic_final <- last_fit(book_wf_final, split = book_split)

logistic_final %>% 
  collect_metrics()
#> # A tibble: 2 x 4
#>   .metric  .estimator .estimate .config             
#>   <chr>    <chr>          <dbl> <chr>               
#> 1 accuracy binary         0.940 Preprocessor1_Model1
#> 2 roc_auc  binary         0.910 Preprocessor1_Model1
```

``` r
logistic_final %>% 
  collect_predictions() %>%
  roc_curve(truth = author, `.pred_Emily Brontë`) %>% 
  autoplot()
```

<img src="roc_curve.png" width="100%" />

The accuracy of our logisitc model rises by a rough 9% to 93.8%, with `roc_auc` being nearly 0.904. This is pretty good!

There is also the confusion matrix to check. The model does well in identifying Charlotte Brontë (low false positive rate, high sensitivity), yet suffers relatively high false negative rate (mistakenly identify 39% of Emily Brontë as Charlotte Brontë, aka low specificity). In part, this is due to class imbalance (four out of five books were written by Charlotte).

``` r
logistic_final %>%
  collect_predictions() %>%
  conf_mat(truth = author, estimate = .pred_class) 
#>                   Truth
#> Prediction         Charlotte Brontë Emily Brontë
#>   Charlotte Brontë             9870          701
#>   Emily Brontë                    1         1208
```

To examine the effect of predictors, I agian use `fit` and `pull_workflow` to extract model fit. Variable importance plots implemented in the [vip](https://koalaverse.github.io/vip/index.html) package provides an intuitive way to visualize importance of predictors in this scenario, using the absolute value of the t-statistic as a measure of VI.

``` r
library(vip)

logistic_vi <- book_wf_final %>% 
  fit(book_train) %>% 
  pull_workflow_fit() %>%
  vi(lambda = top_models[1, ]$penalty) %>% 
  group_by(Sign) %>% 
  top_n(30, wt = abs(Importance)) %>%
  ungroup() %>% 
  mutate(Sign = if_else(Sign == "POS", 
                        "More Emily Brontë", 
                        "More Charlotte Brontë"))

logistic_vi %>% 
  ggplot(aes(y = reorder_within(Variable, abs(Importance), Sign),
             x = Importance)) + 
  geom_col(aes(fill = Sign), 
           show.legend = FALSE, alpha = 0.6) +
  scale_y_reordered() + 
  facet_wrap(~ Sign, nrow = 1, scales = "free") + 
  labs(title = "How word usage classifies Brontë sisters",
       x = NULL,
       y = NULL) + 
  theme(axis.text = element_text(size = 18),
        plot.title = element_text(size = 24),
        plot.title.position = "plot")
```

<div class="figure">

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-25-1.png" alt="Variable importance plot for penalized logistic regression" width="1056" />
<p class="caption">
Figure 1: Variable importance plot for penalized logistic regression
</p>

</div>

Is it cheating to use names of a character to classify authors? Perhaps I should consider include more books and remove names for text classification next time.

Note that variale importance in the left panel is generally smaller than the right, this corresponds to what we find in the [word frequency](#comparing-word-frequency) plot that Emily Brontë has more and stronger characteristic words.

In conclusion, the model with the best lambda seems quite powerful in distinguishing these two authors. I look forward to build a multinomial classification model in `tidymodels` to include Anne Brontë some other time!
