---
title: Analyzing COVID-19 Publications
author: Qiushi Yan
date: '2020-04-06'
slug: [analyzing-covid19-publications]
summary: 'A simple text analysis on the abstract of up-to-date COVID-19 publications.'
lastmod: '2020-05-08T12:54:24+08:00'
featured: no
bibliography: ../bib/covid19.bib
link-citations: yes

categories:
  - Data Analysis
  - R

image:
  caption: 'Image by [cottonbro](https://www.pexels.com/@cottonbro)'
  focal_point: ''
  preview_only: no

---

In this post, I will be performing a simple text analysis on the abstract of publications on the coronavirus disease (COVID-19), courtesy of [WHO](https://www.who.int/emergencies/diseases/novel-coronavirus-2019/global-research-on-novel-coronavirus-2019-ncov). We begin by steps of data preprocessing.

# Data preprocessing

``` r
library(dplyr)
library(ggplot2)
library(stringr)
```

``` r
raw <- vroom::vroom("https://media.githubusercontent.com/media/qiushiyan/blog-data/master/covid-research.csv") %>% 
  janitor::clean_names() 

glimpse(raw)
#> Rows: 4,190
#> Columns: 16
#> $ title            <chr> "SARS-CoV-2 is not detectable in the vaginal fluid of…
#> $ authors          <chr> "Qiu, Lin; Liu, Xia; Xiao, Meng; Xie, Jing; Cao, Wei;…
#> $ abstract         <chr> "Background Severe acute respiratory syndrome coronav…
#> $ published_year   <dbl> 2020, 2020, 2020, 2020, 2020, 2020, 2020, 2020, 2020,…
#> $ published_month  <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ journal          <chr> "Clinical Infectious Diseases", "International Journa…
#> $ volume           <chr> NA, "17", NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ issue            <chr> NA, "7", NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ pages            <chr> NA, "2430-2430", "112275-112275", NA, "1-4", NA, NA, …
#> $ accession_number <chr> NA, NA, NA, NA, NA, NA, NA, "32229574", NA, NA, "3223…
#> $ doi              <chr> "10.1093/cid/ciaa375", "10.3390/IJERPH17072430", "htt…
#> $ ref              <dbl> 26513, 26499, 26744, 26447, 27114, 26388, 26696, 2725…
#> $ covidence_number <chr> "#27487", "#27413", "#27869", "#27815", "#27905", "#2…
#> $ study            <chr> "Qiu 2020", "Pulido 2020", "Pillaiyar 2020", "Piauí 2…
#> $ notes            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ tags             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
```

For simplicity I ignore many of the vairables (mostly for identification) and rows with missing values on `abstract`. I was a little disappointied to find out that `published_month` are all missing, otherwise we may see a trend of some sort on research topics there. One remaining problem is that some of the papers are not written in English.
The `detect_language()` from the [`cdl3`](https://github.com/ropensci/cld3) can detect language forms at a fairly high success rate. It’s a R wrapper for Google’s Compact Language Detector 3, which is a neural network model for language identification.

``` r
library(cld3)
raw %>% 
  count(language = detect_language(abstract), sort = TRUE)
#> # A tibble: 13 × 2
#>    language     n
#>    <chr>    <int>
#>  1 en        2482
#>  2 ig        1618
#>  3 es          26
#>  4 pt          18
#>  5 de          11
#>  6 ru          10
#>  7 fr           7
#>  8 zh           7
#>  9 <NA>         5
#> 10 fi           2
#> 11 ja           2
#> 12 cs           1
#> 13 it           1
```

In this post I keep only the rows that were classified as “en”. Also, as illuatrated in [Text Mining with R](https://www.tidytextmining.com), text analysis commonly requires preprocessing steps like tokenizing, eliminating stop words and word stemming. I added custom keywords and did some maunual transformation to make up for misclassifications by `detect_language`, but there will still be non-English words, though. My transformations (say, both “covid” and “19” now become “covid19”) will certainly induce errors, but there is no better workaround I could think of now.

``` r
library(tidytext)
library(SnowballC)

words <- raw %>% 
  filter(detect_language(abstract) == "en") %>% 
  unnest_tokens(word, abstract) %>% 
  mutate(word = wordStem(word)) %>%
  mutate(word = case_when(
    word == "19" ~ "covid19",
    word == "covid" ~ "covid19",
    word == "coronaviru" ~ "coronavirus",
    word == "viru" ~ "virus",
    word == "epidem" ~ "epidemic",
    word == "studi" ~ "study",
    word == "respiratori" ~ "respiratory",
    word == "emetin" ~ "emetine",
    word == "acut" ~ "acute",
    word == "sever" ~ "severe",
    word == "manag" ~ "manage",
    word == "hospit" ~ "hospital",
    word == "diseas" ~ "disease",
    word == "deceas" ~ "dicease",
    word == "caus" ~ "cause",
    word == "emerg" ~ "emerge",
    word == "includ" ~ "include", 
    word == "dai" ~ "wet nurse",
    word == "ncovid" ~ "ncov",
    word == "countri" ~ "country",
    word == "provid" ~ "provide",
    word == "peopl" ~ "people",
    TRUE ~ word
  )) %>% 
  anti_join(stop_words %>% 
            add_row(word = c( "2", "1",  "dub", "thi", "ha", "wa", "检查", "cd", "gt",
                              "lt", "tnt", "thei"), 
                    lexicon = "custom")) %>% 
  filter(!(str_detect(word, "^\\d+$") | str_detect(word, "^\\d+\\w$")))


words
#> # A tibble: 245,041 × 16
#>    title    authors    published_year published_month journal volume issue pages
#>    <chr>    <chr>               <dbl> <lgl>           <chr>   <chr>  <chr> <chr>
#>  1 SARS-Co… Qiu, Lin;…           2020 NA              Clinic… <NA>   <NA>  <NA> 
#>  2 SARS-Co… Qiu, Lin;…           2020 NA              Clinic… <NA>   <NA>  <NA> 
#>  3 SARS-Co… Qiu, Lin;…           2020 NA              Clinic… <NA>   <NA>  <NA> 
#>  4 SARS-Co… Qiu, Lin;…           2020 NA              Clinic… <NA>   <NA>  <NA> 
#>  5 SARS-Co… Qiu, Lin;…           2020 NA              Clinic… <NA>   <NA>  <NA> 
#>  6 SARS-Co… Qiu, Lin;…           2020 NA              Clinic… <NA>   <NA>  <NA> 
#>  7 SARS-Co… Qiu, Lin;…           2020 NA              Clinic… <NA>   <NA>  <NA> 
#>  8 SARS-Co… Qiu, Lin;…           2020 NA              Clinic… <NA>   <NA>  <NA> 
#>  9 SARS-Co… Qiu, Lin;…           2020 NA              Clinic… <NA>   <NA>  <NA> 
#> 10 SARS-Co… Qiu, Lin;…           2020 NA              Clinic… <NA>   <NA>  <NA> 
#> # … with 245,031 more rows, and 8 more variables: accession_number <chr>,
#> #   doi <chr>, ref <dbl>, covidence_number <chr>, study <chr>, notes <chr>,
#> #   tags <chr>, word <chr>
```

# Common words and keywords extraction

An immediate question is, what are the most common words among all these publications?

``` r
words %>% 
  count(word, sort = TRUE) %>%
  top_n(50) %>%
  ggplot(aes(y = forcats::fct_reorder(word, n),
             x = n)) + 
  geom_col() + 
  scale_x_continuous(expand = c(0.01, 0)) + 
  labs(y = NULL,
       x = "# of words",
       title = "Top 50 common words in COVID-19 publications") +
  theme(text = element_text(size = 18),
        plot.title.position = "plot",
        plot.title = element_text(size = 35, face = "bold"),
        axis.ticks.y = element_blank())
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-7-1.png" width="1152" style="display: block; margin: auto;" />

I’m also interested in paper-specific properties, namely their keywords, what topics distinguish them from others? In comparison to the commonly used algorithm tf-idf, I prefer using weighted log odds proposed by Monroe, Colaresi, and Quinn ([2008](#ref-monroe_colaresi_quinn)), which a standardized metric from a complete statistical model. It is also implemented in the R package [`tidylo`](https://github.com/juliasilge/tidylo)([Schnoebelen and Silge 2020](#ref-tidylo)). The reason is that tf-idf cannot extract the varying use trend of common words, if a word appears in every research paper, then its inverse document frequency will be zero. For weighted log odds this is not the case, even if all researched mentioned this word it can still differentiate those who used it a lot more often from those who used less. This could be essential when we are trying to find an emphasis on which researchers place as our understanding of the virus advances. Sadly I have no access to the exact date of the publication, so I will just display words with topest score and their corresponding publications.

``` r
library(tidylo)

words %>%
  count(title, word) %>% 
  bind_log_odds(set = title, feature = word, n = n) %>%
  top_n(20) %>% 
  knitr::kable()
```

| title                                                                                                                                                 | word    |   n | log_odds_weighted |
|:------------------------------------------------------------------------------------------------------------------------------------------------------|:--------|----:|------------------:|
| A case of 2019 Novel Coronavirus in a pregnant woman with preterm delivery                                                                            | covid19 |   4 |             363.5 |
| A cause for concern                                                                                                                                   | covid19 |   2 |             284.7 |
| COVID-19 Presents High Risk to Older Persons                                                                                                          | avail   |   1 |               Inf |
| Diagnosis and Treatment of an Acute Severe Pneumonia Patient with COVID-19: Case Report                                                               | covid19 |   2 |             238.5 |
| Drug trials under way                                                                                                                                 | covid19 |   2 |             263.8 |
| Fast, portable tests come online to curb coronavirus pandemic                                                                                         | covid19 |   2 |             259.5 |
| Handle the Autism Spectrum Condition During Coronavirus (COVID-19) Stay At Home period: Ten Tips for Helping Parents and Caregivers of Young Children | covid19 |   2 |             377.2 |
| Heavy hitters join for coronavirus treatments                                                                                                         | covid19 |   2 |             263.7 |
| I May Not Have Symptoms, but COVID-19 Is a Huge Headache                                                                                              | covid19 |   2 |             236.5 |
| Researchers: show world leaders how to behave in a crisis                                                                                             | covid19 |   2 |             270.5 |
| Suppressing early information on COVID-19 and other health scares can aid misinformation                                                              | covid19 |   2 |             367.8 |
| Ten Weeks to Crush the Curve                                                                                                                          | covid19 |   2 |             290.8 |
| The Invisible Hand — Medical Care during the Pandemic                                                                                                 | covid19 |   2 |             267.9 |
| Thinking Globally, Acting Locally — The U.S. Response to Covid-19                                                                                     | covid19 |   2 |             274.7 |
| Time to use the p-word? Coronavirus enters dangerous new phase                                                                                        | covid19 |   4 |             263.6 |
| Undocumented U.S. Immigrants and Covid-19                                                                                                             | covid19 |   2 |             376.7 |
| We practised for a pandemic, but didn’t brace                                                                                                         | health  |   1 |             243.0 |
| WHO IHR Emergency Committee for the COVID-19 Outbreak                                                                                                 | avail   |   1 |               Inf |
| Why the WHO won’t use the p-word                                                                                                                      | covid19 |   2 |             255.7 |
| World in lockdown                                                                                                                                     | covid19 |   2 |             276.4 |

Many words listed here are acronyms and terms in biology, chemistry and medicine. For example, “hljby” is a type of **p**orcine **e**pidemic **d**iarrhoea **v**irus which “pedv” stands for, “fpv” means **F**avi**p**ira**v**ir (a type of drug), and “tlr” represents **T**oll-**l**ike **r**eceptors.

# Fit a LDA topic model

Let’s then fit a 5-topic LDA topic model, before that we should convert the data frame to a docuemnt term matrix using `cast_dtm`. There are various implementations of this kind of model, here I use `stm::stm`. The choice of `\(K\)` (number of topics) here is somewhat arbitrary here, but [Julia Silge](https://juliasilge.com/) had a great [post](https://juliasilge.com/blog/evaluating-stm/) about it.

``` r
dfm <- cast_dfm(words %>% count(title, word),
                term = word,
                document = title,
                value = n)
```

`dfm` is a document-term matrix with 2415 documents and 13383 features.

``` r
library(stm)
topic_model <- stm(dfm, K = 5, init.type = "LDA", verbose = FALSE)
```

Topic-term probability distributions are accessed by `tidy()`, this gives a glance of the underlying meaning of these topics:

``` r
# topic-term distribution
tidy(topic_model) %>% 
  group_by(topic) %>% 
  top_n(10) %>% 
  ungroup() %>%
  mutate(topic = factor(topic) %>% str_c("topic", .)) %>% 
  ggplot(aes(y = reorder_within(term, beta, topic),
         x = beta,
         fill = topic)) + 
  geom_col(show.legend = FALSE) + 
  scale_y_reordered() + 
  facet_wrap(~ topic, scales = "free_y", nrow = 3) + 
  labs(y = NULL,
       x = "Docuemtn-term probabilities",
       title = "A 6-topic LDA model") + 
  theme(text = element_text(size = 18),
        plot.title = element_text(size = 30, face = "bold"),
        strip.text = element_text(size = 25, hjust = 0.05),
        axis.ticks.y = element_blank())
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-11-1.png" width="1152" style="display: block; margin: auto;" />

It’s hard to interpret these topics without domain knwoledge. But it seems to me that topic3 is related to clinical findings, topic4 to china and wuhan, the epicenter of covid19.

# A network of paired words

Another question of interest is the relationship between words: what group of words tend to appear together? I look at the [phi coefficient](https://en.wikipedia.org/wiki/Phi_coefficient), which is essentailly `\(\chi^2\)` statistc in a contingency table applied to categorical variables.

As each abstract is a natual unit of measure, a pair of words that both appear in the same abstract are seen as “appearing together”. We could compute `\(\phi\)` based on pairwise counts:

``` r
library(widyr)

word_cors <- words %>% 
  add_count(word) %>% 
  filter(n > 20) %>%
  select(-n) %>%
  pairwise_cor(item = word, feature = title, sort = TRUE)

word_cors
#> # A tibble: 2,385,480 × 3
#>    item1        item2        correlation
#>    <chr>        <chr>              <dbl>
#>  1 arabia       saudi              1    
#>  2 saudi        arabia             1    
#>  3 pave         crazi              0.970
#>  4 crazi        pave               0.970
#>  5 kong         hong               0.935
#>  6 hong         kong               0.935
#>  7 dehydrogenas lactat             0.931
#>  8 lactat       dehydrogenas       0.931
#>  9 reserv       copyright          0.928
#> 10 copyright    reserv             0.928
#> # … with 2,385,470 more rows
```

A network visualization of word correlation is a good idea:

``` r
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

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-13-1.png" width="1152" style="display: block; margin: auto;" />

As you can see, there are still some non-English words that stemming and adding stopwrods cannot handle… Nonetheless, we are be able to identify some of the clusters revovling around infant infection (infant, pregnant, newborn, mother), pathology (angiotensin, protein, receptor), symptoms (lung, thicken, lesion), etc.

# References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-monroe_colaresi_quinn" class="csl-entry">

Monroe, Burt L., Michael P. Colaresi, and Kevin M. Quinn. 2008. “Fightin’ Words: Lexical Feature Selection and Evaluation for Identifying the Content of Political Conflict.” *Political Analysis* 16 (4): 372–403. <https://doi.org/10.1093/pan/mpn018>.

</div>

<div id="ref-tidylo" class="csl-entry">

Schnoebelen, Tyler, and Julia Silge. 2020. *Tidylo: Tidy Log Odds Ratio Weighted by Uninformative Prior*. <http://github.com/juliasilge/tidylo>.

</div>

</div>
