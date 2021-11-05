---
title: Analyzing Animal Crossing Reviews
author: Qiushi Yan
date: '2020-05-07'
categories:
  - Data Analysis
  - Machine Learning
  - R
tags: []
summary: 'Practice on data cleaning, text analysis and multicategory logistic models with penalization'
image:
  caption: ''
  focal_point: ''
  preview_only: yes
---

In this post I analyzed reviews for the life simulation video game, Animal Crossing. The data came from [this weeks's `#TidyTuesday`](https://github.com/rfordatascience/tidytuesday/blob/master/data/2020/2020-05-05/readme.md), scraped from [VillagerDB](https://github.com/jefflomacy/villagerdb) and [Metacritic](https://www.metacritic.com/game/switch/animal-crossing-new-horizons/critic-reviews). I used only the `reviews` table, but there are a lot more to analyze such as characters and items in the game.   

The data appeared a bit messy after some EDA, and regular expressions played a major role in data cleaning. After that I made some plots concerning the review text, such as common words or high score words from an algorithm. Highly correlated words in user reviews were shown with nodes and edges. Then I built a multicategory logit model to predict ratings (low, medium or high) with predictors including the reviewing date and usage of specific words.  




```r
library(tidyverse)
library(tidytext)
```




# EDA and data cleaning

The reviews data contains four columns:

- `grade`: 0-100 score given by the critic (missing for some) where higher score = better.
- `user_name`: user name of the reviewer
- `text`: review of the reviewer
- `date`: when the review is published


```r
reviews <- vroom::vroom("https://media.githubusercontent.com/media/qiushiyan/blog-data/master/animal-crossing-reviews.tsv")
glimpse(reviews)
#> Rows: 1,472
#> Columns: 4
#> $ grade     <dbl> 4, 5, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, …
#> $ user_name <chr> "mds27272", "lolo2178", "Roachant", "Houndf", "ProfessorFox"…
#> $ text      <chr> "My gf started playing before me. No option to create my own…
#> $ date      <date> 2020-03-20, 2020-03-20, 2020-03-20, 2020-03-20, 2020-03-20,…
```


 


A bar plot of all grades show a bimodal distribution. This is perhaps not that astonishing when it comes to reviewing, since people tend to go to extremes and give polarized opinions. This may suggest that we cut `grades` into discrete levels and build a classification model afterwards, rather than modeling bare grades itself with regression models. 

```r
reviews %>% 
  count(grade) %>% 
  ggplot() + 
  geom_col(aes(x = factor(grade), 
               y = n),
           fill = "midnightblue", alpha = 0.6) + 
  labs(x = "grade", y = NULL)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-5-1.png" width="768" style="display: block; margin: auto;" />


The data is messy in several ways (I have chosen 3 observations from the `text` column for example):  

- Review contains repetition. the following review where the first 4.5 lines are repeated in the following lines



> "While the game itself is great, really relaxing and gorgeous, i can't ignore one thing that ruins the whole experience for me and a lot of other people as seen by the different user reviews.That thing is that you only have 1 island per console. This decision limits to one person being able to enjoy the full experience. It also nukes any creative control of the island, since you haveWhile the game itself is great, really relaxing and gorgeous, i can't ignore one thing that ruins the whole experience for me and a lot of other people as seen by the different user reviews.That thing is that you only have 1 island per console. This decision limits to one person being able to enjoy the full experience. It also nukes any creative control of the island, since you have the other usershouse and furniture. I hope nintendo can soon fix this big issue, because for now, this killed any intentions i had to play the game.… Expand"   


- Reviews that exceed certain length are incomplete and end with "Expand". The following review also contains repeated lines.


> "One island per console is a design decision that is, at best, in poor taste, and at worst, straight-up predatory behavior.Per console, only one player gets to experience the game at its fullest. The other players see less dialogue, experience less events, and are locked out entirely from certain parts of the game.No matter how good a game is, I cannot stand behind a company thatOne island per console is a design decision that is, at best, in poor taste, and at worst, straight-up predatory behavior.Per console, only one player gets to experience the game at its fullest. The other players see less dialogue, experience less events, and are locked out entirely from certain parts of the game.No matter how good a game is, I cannot stand behind a company that sees fit to make such decisions.… Expand" 


- non-English reviews


> "Una sola isla , es un asco . No puedes seguir avanzando, solo te queda recoger madera"  


I use regular expressions to remove repeated lines as well as "Expand" at the end. Repetitions happen when the review is long, and the repetition part often takes up 4 to 5 lines (here I use 350 or more characters to indicate the repetition part). 

`clr::detect_language` is used to exclude non-English text. This a R wrapper around Google's Compact Language Detector 3, a neural network model for language identification. There will be misclassifications, though. As the proportion of exclusion is fairly low, we're OK.  Lastyly, et's split `grade` 3  ordered categories, low, medium and high.


```r
library(cld3)

# most text are detected as English
reviews %>% 
  mutate(language = detect_language(text)) %>% 
  count(language, sort = TRUE)
#> # A tibble: 11 x 2
#>    language     n
#>    <chr>    <int>
#>  1 en        1393
#>  2 es          48
#>  3 ru           7
#>  4 it           6
#>  5 fr           5
#>  6 pt           5
#>  7 de           3
#>  8 <NA>         2
#>  9 ja           1
#> 10 pl           1
#> 11 th           1
```




```r
reviews_en <- reviews %>% 
  filter(detect_language(text) == "en")


repetition_clean <- reviews_en %>% 
  filter(str_detect(text, "(.{350,})\\1.+")) %>% 
  mutate(text = str_replace(text, "(.{350,})\\1(.+)Expand$", "\\1\\2"))

reviews_clean <- anti_join(reviews_en, repetition_clean, 
                           by = c("user_name" = "user_name")) %>% 
  bind_rows(repetition_clean) %>% 
  mutate(rating = case_when(
    grade <= 2 ~ "low",
    grade > 2 & grade < 8 ~ "medium",
    grade >= 8 ~ "high",
  ) %>% factor(levels = c("low", "medium", "high")))
```

Now, `rating` is a factor with 3 levels. Low and high ratings are rougly the same size, and medium ratings are relatively rare.

```r
reviews_clean %>% 
  count(rating)
#> # A tibble: 3 x 2
#>   rating     n
#>   <fct>  <int>
#> 1 low      625
#> 2 medium   136
#> 3 high     632
```



We can examine how this cleaning process works by comparing the distribution of review length, before and after. The cleaning should reduce the amount of medium long and long reviews, in exchange for shorter ones.

```r
reviews %>%
  transmute(length = str_length(text),
            type = "before") %>% 
  bind_rows(reviews_clean %>%
              transmute(length = str_length(text), type = "after")) %>%
  ggplot() + 
  geom_density(aes(length, fill = type), alpha = 0.2) + 
  scale_fill_discrete(name = NULL) + 
  labs(title = "Distribution of review length (characters) before and after cleaning",
       x = NULL,
       y = NULL)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-9-1.png" width="768" style="display: block; margin: auto;" />




# Text analysis of user reviews 

Our text analysis begin by tokenizing review text to find out what are the most common words (by term frequency) for each category of reviews.  



```r
words <- reviews_clean %>% 
  select(rating, text) %>% 
  unnest_tokens(word, text) %>% 
  anti_join(stop_words) %>% 
  filter(!str_detect(word, "^\\d+$"))
 

common_words <- words %>% 
  count(rating, word, sort = TRUE, name = "term_count") %>% 
  add_count(rating, wt = term_count, name = "total_count") %>% 
  mutate(term_freq = term_count / total_count)  %>% 
  group_by(rating) %>% 
  top_n(30, term_freq)
```


```r
ggplot(common_words, 
       aes(y = reorder_within(word, term_freq, rating),
           x = term_freq,
           fill = rating)) + 
  geom_col(show.legend = FALSE, alpha = 0.6) + 
  scale_y_reordered() + 
  scale_x_continuous(label = scales::label_percent()) + 
  nord::scale_fill_nord(palette = "afternoon_prarie") +
  facet_wrap(~ rating, scales = "free_y", strip.position = "bottom") + 
  labs(title = "Most common words in different levels of reviews",
       x = "term frequency",
       y = NULL) + 
  hrbrthemes::theme_modern_rc() + 
  theme(panel.grid.major.y = element_blank(),
        plot.title = element_text(face = "bold", size = 28),
        plot.title.position = "plot",
        axis.text.y = element_text(size = 16),
        axis.text.x = element_text(size = 12),
        axis.title.x = element_text(size = 16), 
        strip.text = element_text(size = 20, color = "white")) 
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-11-1.png" width="1344" style="display: block; margin: auto;" />


As it is, this plot aren't that helpful for all categories share a very similar set of words. For this reason I turn to two other algorithms developed for information retrieval: tf-idf and weighted log odds.


```r
library(tidylo)

key_words <- words %>% 
  count(rating, word, sort = TRUE) %>% 
  bind_tf_idf(term = word, document = rating, n = n) %>%
  left_join(words %>% 
              count(rating, word, sort = TRUE) %>% 
              bind_log_odds(set = rating, feature = word, n = n),
            by = c("rating" = "rating", "word" = "word", "n" = "n")) %>% 
  select(rating, word, tf_idf, log_odds = log_odds_weighted)

key_words
#> # A tibble: 9,162 x 4
#>    rating word     tf_idf log_odds
#>    <fct>  <chr>     <dbl>    <dbl>
#>  1 low    game          0   -2.48 
#>  2 high   game          0   -0.902
#>  3 low    island        0    0.772
#>  4 low    switch        0    2.07 
#>  5 low    play          0    2.10 
#>  6 low    player        0    3.40 
#>  7 high   island        0   -3.19 
#>  8 low    nintendo      0    2.95 
#>  9 medium game          0    4.19 
#> 10 high   animal        0    3.94 
#> # ... with 9,152 more rows
```


Make separate plot for two measures and then combine them together. 


```r
tf_idf <- key_words %>% 
  group_by(rating) %>% 
  arrange(-tf_idf) %>% 
  slice(1:20) %>% 
  ggplot(aes(
    y = reorder_within(word, tf_idf, rating),
    x = tf_idf,
    fill = rating)) + 
  geom_col(show.legend = FALSE, alpha = 0.6) + 
  scale_y_reordered() + 
  scale_x_continuous(position = "top") + 
  nord::scale_fill_nord(palette = "afternoon_prarie") +
  facet_wrap(~ rating, scales = "free_y", strip.position = "bottom") + 
  labs(title = "High tf-idf words",
       x = NULL,
       y = NULL) + 
  hrbrthemes::theme_modern_rc() + 
  theme(panel.grid.major.y = element_blank(),
        plot.title = element_text(face = "bold", size = 28),
        plot.title.position = "plot",
        axis.text.y = element_text(size = 16),
        axis.text.x = element_text(size = 12),
        axis.title.x = element_text(size = 16), 
        strip.text = element_text(size = 24, color = "white")) 

log_odds <- key_words %>% 
  group_by(rating) %>% 
  top_n(20, log_odds) %>%
  ggplot(aes(
    y = reorder_within(word, log_odds, rating),
    x = log_odds,
    fill = rating)) + 
  geom_col(show.legend = FALSE, alpha = 0.6) + 
  scale_y_reordered() + 
  scale_x_continuous(position = "top") +  
  nord::scale_fill_nord(palette = "afternoon_prarie") +
  facet_wrap(~ rating, scales = "free_y", strip.position = "bottom") + 
  labs(title = "High log-odds words",
       x = NULL,
       y = NULL) + 
  hrbrthemes::theme_modern_rc() + 
  theme(panel.grid.major.y = element_blank(),
        plot.title = element_text(face = "bold", size = 28),
        plot.title.position = "plot",
        axis.text.y = element_text(size = 16),
        axis.text.x = element_text(size = 12),
        axis.title.x = element_text(size = 16), 
        strip.text = element_blank()) 

patchwork::wrap_plots(tf_idf, log_odds, nrow = 2)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-13-1.png" width="1344" style="display: block; margin: auto;" />

This is a abit better, isn't it :sweat_smile:? The `tf_idf` plot performed well in identifying characteristic words in low ratings like "unacceptable", "wtf" and "boring", While the `log_odds` plot shows a somewhat dominance of words like "fun", "cute" and "relaxing" in high ratings.


Additionally, we may also be interested in words that tend to co-occur within a particular review. For simplicity I focus on long reviews only (more than 800 characters).   


```r
library(widyr)

word_cors <- reviews_clean %>%  
  filter(str_length(text) > 800) %>%
  select(user_name, text) %>% 
  unnest_tokens(word, text) %>% 
  anti_join(stop_words) %>% 
  filter(!str_detect(word, "^\\d+$")) %>% 
  group_by(word) %>% 
  filter(n() > 10) %>% 
  count(user_name, word) %>% 
  pairwise_cor(item = word, feature = user_name, value = n)

word_cors
#> # A tibble: 102,720 x 3
#>    item1      item2 correlation
#>    <chr>      <chr>       <dbl>
#>  1 ability    3ds       -0.0402
#>  2 absolutely 3ds       -0.0125
#>  3 ac         3ds        0.158 
#>  4 access     3ds       -0.0457
#>  5 account    3ds        0.170 
#>  6 accounts   3ds        0.271 
#>  7 activities 3ds        0.0348
#>  8 add        3ds        0.0216
#>  9 addition   3ds        0.0770
#> 10 additional 3ds       -0.0414
#> # ... with 102,710 more rows
```


```r
library(ggraph)
library(tidygraph)

word_cors %>%
  filter(correlation > 0.4) %>% 
  as_tbl_graph() %>% 
  ggraph(layout = "fr") + 
  geom_edge_link(aes(alpha = correlation), show.legend = FALSE) + 
  geom_node_point(color = "lightblue", size = 6.5) + 
  geom_node_text(aes(label = name), repel = TRUE, size = 5.5)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-15-1.png" width="960" style="display: block; margin: auto;" />




# Predictive modeling for rating

It takes some steps to derive from `reviews_clean` a design matrix for modeling. The [`textrecipes`](https://tidymodels.github.io/textrecipes/index.html) package contains extra steps for `recipes` for preprocessing text data that could have replaced my manual wrangling. 


```r
library(lubridate)

model_df <- reviews_clean %>% 
  filter(across(everything(), ~ sum(is.na(.)) == 0)) %>% 
  transmute(rating, 
            user_name, 
            text,
            t = as.numeric(date - ymd("2020-03-20"))) %>%
  unnest_tokens(word, text) %>% 
  anti_join(stop_words) %>%
  count(user_name, t, rating, word, name = "word_count") %>% 
  group_by(word) %>% 
  filter(n() > 20, word != "rating", !str_detect(word, "^\\d+$")) %>% 
  ungroup() %>% 
  pivot_wider(names_from = word, values_from = word_count, 
              values_fill = list(word_count = 0), names_repair = "minimal")
  

model_df
#> # A tibble: 1,392 x 320
#>    user_name         t rating playing  stop ability accounts   buy `can’t` console
#>    <chr>         <dbl> <fct>    <int> <int>   <int>    <int> <int>   <int>   <int>
#>  1 000PLAYER000      0 high         1     1       0        0     0       0       0
#>  2 11_11             4 low          1     0       1        3     2       1       2
#>  3 12hwilso          4 low          0     0       0        1     0       0       2
#>  4 3nd3r02           6 low          0     0       0        0     0       0       0
#>  5 425_Flex          3 low          0     0       0        0     0       0       0
#>  6 486eHyMy          2 low          0     0       0        0     0       0       0
#>  7 4Plants           5 high         0     0       0        0     0       0       0
#>  8 8bheotapus        6 low          0     0       0        0     0       0       2
#>  9 A_Mighty_Pleb     6 medium       3     0       0        1     3       0       0
#> 10 a0972354          4 high         0     0       0        0     0       0       0
#> # ... with 1,382 more rows, and 310 more variables: consoles <int>,
#> #   don’t <int>, excited <int>, extremely <int>, families <int>, forcing <int>,
#> #   fun <int>, game <int>, games <int>, greedy <int>, household <int>,
#> #   island <int>, money <int>, multiple <int>, nintendo <int>, play <int>,
#> #   purchase <int>, saves <int>, separate <int>, sister <int>, spent <int>,
#> #   stupid <int>, true <int>, account <int>, broken <int>, fix <int>,
#> #   people <int>, progress <int>, 1st <int>, animal <int>, crossing <int>, ...
```

After tokenizing, filtering and some other steps, I have a ready-for-modeling design matrix at hand. `user_name` is an ID variable, `t` indicates the number of days after 2020-03-20 when the first review was made. All other columns, besides the response `rating`, are word counts used as term weighting.  


Next, let's split the data into training and testing test with stratified sampling on `rating`.

```r
library(tidymodels)

set.seed(2020)
reviews_split <- initial_split(model_df, strata = rating)
reviews_train <- training(reviews_split)
reviews_test <- testing(reviews_split)
```

I will fit a multinomial logistic regression model implemented by the `glmnet` package, with L1 regularization as in the lasso model. To detect medium ratings more accurately, the minority class, `step_upsample` will bring the number of medium and high ratings up to the same (`over_ratio = 1` ) as that of low ratings. And `tune_gird()` will calculate model performance metrics averaged over 25 bootstrap resamples for 100 choices of lambda. 

```r
multinom_spec <- multinom_reg(mixture = 1, penalty = tune()) %>% 
  set_engine("glmnet") %>% 
  set_mode("classification") 

library(themis)
rec <- recipe(rating ~ ., data = reviews_train) %>%
  update_role(user_name, new_role = "ID") %>% 
  step_upsample(rating, over_ratio = 1) %>% 
  step_normalize(all_predictors())

lambda_grid <- grid_regular(penalty(), levels = 100)
  
reviews_folds <- bootstraps(reviews_train, strata = rating)

wf <- workflow() %>% 
  add_model(multinom_spec) %>% 
  add_recipe(rec)

doParallel::registerDoParallel()

multinom_search <- tune_grid(wf, 
                    resamples = reviews_folds,
                    grid = lambda_grid,
                    metrics = metric_set(roc_auc, accuracy, kap))
```


Available metrics are ROC AUC, accuracy and Kappa. In the multi-class case, accuracy and Kappa use the same definitions as their binary counterpart, with accuracy counting up the number of correctly predicted true values out of the total number of true values, and Kappa being a linear combination of two accuracy values, sensitivity and specificity. Multi-class ROC AUC, however, is implemented using the "hand_till" method. 


```r
multinom_search %>%
  collect_metrics() %>% 
  ggplot(aes(penalty, mean, color = .metric)) + 
  geom_line() + 
  geom_errorbar(aes(ymax = mean + std_err, ymin = mean - std_err)) + 
  scale_x_log10(labels = scales::label_number_auto()) + 
  facet_wrap(~ .metric, scales = "free_y") + 
  labs(y = NULL, x = expression(lambda)) + 
  theme(legend.position = "none")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-19-1.png" width="960" style="display: block; margin: auto;" />

It's clear from the plot that all 3 metrics benefit from appropriate regularization, and we can identify a local maximum in all panels at roughly the same lambda. Here I use the "one-standard error rule" that selects model with largest lambda that is within one standard error of the numerically optimal Kappa metric.


```r
best_lambda <- multinom_search %>% 
  select_by_one_std_err(metric = "kap", desc(penalty))

best_lambda
#> # A tibble: 1 x 9
#>   penalty .metric .estimator  mean     n std_err .config            .best .bound
#>     <dbl> <chr>   <chr>      <dbl> <int>   <dbl> <chr>              <dbl>  <dbl>
#> 1  0.0152 kap     multiclass 0.521    25 0.00536 Preprocessor1_Mod~ 0.525  0.519
```

We can finalize and fill the model with this lambda. 


```r
wf_final <- finalize_workflow(wf, best_lambda)

final_model <- last_fit(wf_final, split = reviews_split, 
                        metrics = metric_set(roc_auc, accuracy, kap))
```


For our model, the confusion matrix becomes 3 x 3. 


```r
final_model %>% 
  collect_predictions() %>% 
  conf_mat(rating, estimate = .pred_class)
#>           Truth
#> Prediction low medium high
#>     low    120     19   14
#>     medium  23     12   12
#>     high    14      7  128
```

Thanks to downsampling, the classifier performs consistently in predicting these 3 categories. Detection for low ratings may leave some room for improvement. 


Then we could examine these metrics on the model applied to testing set. 


```r
final_model %>% 
  collect_metrics()
#> # A tibble: 3 x 4
#>   .metric  .estimator .estimate .config             
#>   <chr>    <chr>          <dbl> <chr>               
#> 1 accuracy multiclass     0.745 Preprocessor1_Model1
#> 2 kap      multiclass     0.575 Preprocessor1_Model1
#> 3 roc_auc  hand_till      0.764 Preprocessor1_Model1
```


These number may not look so nice in terms of accuracy and ROC AUC, but there is a tradeoff happening. When I was still experimenting on different models I trained one that would miss all the medium ratings in the testing set, but did achieve relatively high predictive metrics. Then I decided to add the `step_upsampling` step to enhance detection towards medium ratings. Although the game campany may not actually care about those mild people as much as they do about those go to extremes. For another, the best penality is judged by the Kappa statistic, which shows reasonable agreement.

Varible importance plot could help us to identify useful features. For multiclass logit models, importance is defined as the sum of absolute value of coef of a variable. For example, in our baseline logit models:


$$
`\begin{aligned}
\log(\frac{P(medium)}{P(low)}) &= \beta_20 + \beta_{21}x_1 + \cdots + \beta_{2p}x_p \\
\log(\frac{P(high)}{P(low)}) &= \beta_30 + \beta_{31}x_1 + \cdots + \beta_{3p}x_p
\end{aligned}`
$$

The absolute value of variable importance for predictor `\(x_1\)` is `\(|\hat{\beta}_{21}| + |\hat{\beta}_{31}|\)`.  

Now I inspect predictors with top absolute variable importance to conclude this minimal project. If a predictor has high positive / negative importance, then it help us to judge whether a user is more intended to give higher ratings or otherwise, similar to sentiment analysis.


```r
final_fit <- wf_final %>% fit(data = reviews_train)
```


```r
library(vip)

importance <- final_fit %>% 
  extract_fit_parsnip() %>% 
  vi() 
```







```r
importance %>% 
  group_by(Sign) %>%
  slice_max(order_by = abs(Importance), n = 20) %>%
  ungroup() %>%
  mutate(Sign = if_else(Sign == "NEG", "lower ratings", "higher ratings")) %>%
  ggplot(aes(y = reorder_within(Variable, abs(Importance), Sign),
             x = Importance,
             fill = Sign)) +
  geom_col(show.legend = FALSE, alpha = 0.5) +
  scale_y_reordered() +
  facet_wrap(~ Sign, scales = "free") +
  labs(y = NULL) +
  theme(axis.text = element_text(size = 20),
        panel.grid.major.y = element_blank(),
        strip.text = element_text(size = 24, face = "bold"))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-27-1.png" width="960" style="display: block; margin: auto;" />


