
# Relationships between words: n-grams and correlations







## Tokenizing by n-gram     


`unnest_tokens()` have been used to tokenize the text by word, or sometimes by sentence, which is useful for the kinds of sentiment and frequency analyses. But we can also use the function to tokenize into consecutive sequences of words of length `n`, called **n-grams**.  

We do this by adding the `token = "ngrams"` option to unnest_tokens(), and setting n to the number of words we wish to capture in each n-gram. When we set `n`to 2, we are examining pairs of two consecutive words, often called “bigrams”:


```r
library(janeaustenr)

austen_bigrams <- austen_books() %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2)

austen_bigrams %>%
  count(bigram, sort = TRUE)
#> # A tibble: 211,236 x 2
#>   bigram      n
#>   <chr>   <int>
#> 1 of the   3017
#> 2 to be    2787
#> 3 in the   2368
#> 4 it was   1781
#> 5 i am     1545
#> 6 she had  1472
#> # ... with 2.112e+05 more rows
```

### Filtering n-grams  


As one might expect, a lot of the most common bigrams are pairs of common (uninteresting) words, such as of the and to be: what we call “stop-words” (see Chapter 1). This is a useful time to use `tidyr::separate()`, which splits a column into multiple based on a delimiter. This lets us separate it into two columns, filter out stop words separately, and then combine the results.  

```r
austen_separated <- austen_bigrams %>%  
  separate(bigram, into = c("word1", "word2"), sep = " ")


austen_united <- austen_separated %>%
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word) %>%
  unite(bigram, c(word1, word2), sep = " ")

austen_united %>% count(bigram, sort = TRUE)
#> # A tibble: 33,421 x 2
#>   bigram                n
#>   <chr>             <int>
#> 1 sir thomas          287
#> 2 miss crawford       215
#> 3 captain wentworth   170
#> 4 miss woodhouse      162
#> 5 frank churchill     132
#> 6 lady russell        118
#> # ... with 3.342e+04 more rows
```



```r
austen_bigrams <- austen_bigrams %>% 
  separate(bigram, into = c("word1", "word2"), sep = " ") %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word) %>% 
  unite(bigram, c(word1, word2), sep = " ")

austen_bigrams
#> # A tibble: 44,784 x 2
#>   book                bigram                  
#>   <fct>               <chr>                   
#> 1 Sense & Sensibility jane austen             
#> 2 Sense & Sensibility austen 1811             
#> 3 Sense & Sensibility 1811 chapter            
#> 4 Sense & Sensibility chapter 1               
#> 5 Sense & Sensibility norland park            
#> 6 Sense & Sensibility surrounding acquaintance
#> # ... with 4.478e+04 more rows
```

### Analyzing bigrams  

The result of separating bigrams is helpful for exploratory analyses of the text. As a simple example, we might be interested in the most common “streets” mentioned in each book:  


```r
austen_bigrams %>% 
  separate(bigram, into = c("word1", "word2"), sep = " ")  %>% 
  filter(word2 == "street") %>% 
  count(street = str_c(word1, word2, sep = " "), sort = TRUE)
#> # A tibble: 28 x 2
#>   street              n
#>   <chr>           <int>
#> 1 berkeley street    16
#> 2 harley street      16
#> 3 milsom street      16
#> 4 pulteney street    15
#> 5 wimpole street     10
#> 6 bond street         9
#> # ... with 22 more rows
```


A bigram can also be treated as a term in a document in the same way that we treated individual words. For example, we can look at the weighted log odds (Section \@ref(weighted-log-odds-ratio)) of bigrams across Austen novels.  


```r
library(tidylo)

austen_bigrams %>% 
  count(book, bigram, sort = TRUE) %>% 
  bind_log_odds(set = book, feature = bigram, n = n) %>% 
  group_by(book) %>% 
  top_n(15) %>% 
  ungroup() %>%
  facet_bar(y = bigram, x = log_odds, by = book, nrow = 3)
```

<img src="relationship-between-words_files/figure-html/unnamed-chunk-6-1.png" width="1152" style="display: block; margin: auto;" />


### Using bigrams to provide context in sentiment analysis    

Context matters in sentiment analysis. For example, the words “happy” and “like” will be counted as positive, even in a sentence like 

> "I'm not happy and I don't like it!"

Now that we have the data organized into bigrams, it’s easy to tell how often words are preceded by a word like "not":


```r
austen_separated %>% 
  filter(word1 == "not") %>% 
  filter(!word2 %in% stop_words$word) %>%
  count(word1, word2, sort = TRUE)
#> # A tibble: 988 x 3
#>   word1 word2          n
#>   <chr> <chr>      <int>
#> 1 not   hear          39
#> 2 not   speak         35
#> 3 not   expect        34
#> 4 not   bear          33
#> 5 not   imagine       26
#> 6 not   understand    26
#> # ... with 982 more rows
```

Let’s use the AFINN lexicon for sentiment analysis, which you may recall gives a numeric sentiment value for each word, with positive or negative numbers indicating the direction of the sentiment.


```r
not_words <- austen_separated %>%
  filter(word1 == "not") %>%
  inner_join(get_sentiments("afinn"), by = c(word2 = "word")) %>%
  count(word1, word2, value, sort = TRUE)

not_words
#> # A tibble: 245 x 4
#>   word1 word2 value     n
#>   <chr> <chr> <dbl> <int>
#> 1 not   like      2    99
#> 2 not   help      2    82
#> 3 not   want      1    45
#> 4 not   wish      1    39
#> 5 not   allow     1    36
#> 6 not   care      2    23
#> # ... with 239 more rows
```


It’s worth asking which words contributed the most in the “wrong” direction. To compute that, we can multiply their value by the number of times they appear (so that a word with a value of +3 occurring 10 times has as much impact as a word with a sentiment value of +1 occurring 30 times). We visualize the result with a bar plot  


```r
not_words %>%
  mutate(contribution = n * value,
         sign = if_else(value > 0, "postive", "negative")) %>%
  top_n(20, abs(contribution)) %>%
  mutate(word2 = fct_reorder(word2, contribution)) %>%
  ggplot(aes(y = word2, x = contribution, fill = sign)) +
  geom_col() +
  labs(y = 'Words preceded by \"not\"',
       x = "Sentiment value * number of occurrences")
```

<img src="relationship-between-words_files/figure-html/unnamed-chunk-9-1.png" width="768" style="display: block; margin: auto;" />

The bigrams “not like” and “not help” were overwhelmingly the largest causes of misidentification, making the text seem much more positive than it is. But we can see phrases like “not afraid” and “not fail” sometimes suggest text is more negative than it is.

“Not” isn’t the only term that provides some context for the following word. We could pick four common words `not`, `no`, `never` and `without` that negate the subsequent term, and use the same joining and counting approach to examine all of them at once.  


```r
negation_words <- c("not", "no", "never", "without")

negated_words <- austen_separated %>%
  filter(word1 %in% negation_words) %>%
  inner_join(get_sentiments("afinn"), by = c(word2 = "word")) %>%
  count(word1, word2, value, sort = TRUE)

negated_words %>%
  mutate(contribution = n * value,
         sign = if_else(value > 0, "postive", "negative")) %>%
  group_by(word1) %>% 
  top_n(20, abs(contribution)) %>%
  ungroup() %>%
  ggplot(aes(y = reorder_within(word2, contribution, word1), 
             x = contribution, 
             fill = sign)) +
  geom_col() + 
  scale_y_reordered() + 
  facet_wrap(~ word1, scales = "free") + 
  labs(y = 'Words proceeded by a negation term',
       x = "Sentiment value * number of occurrences",
       title = "The most common positive or negative words to follow negations such as 'never', 'no', 'not', and 'without'")
```

<img src="relationship-between-words_files/figure-html/unnamed-chunk-10-1.png" width="960" style="display: block; margin: auto;" />

### Visualizing a network of bigrams with `ggraph`  


```r
library(tidygraph)
library(ggraph)
```



```r
bigram_counts <- austen_separated %>% 
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word) %>% 
  count(word1, word2, sort = TRUE) 
```



```r
bigram_graph <- bigram_counts %>% 
  filter(n > 20) %>%
  as_tbl_graph()

bigram_graph
#> # A tbl_graph: 91 nodes and 77 edges
#> #
#> # A directed acyclic simple graph with 17 components
#> #
#> # Node Data: 91 x 1 (active)
#>   name   
#>   <chr>  
#> 1 sir    
#> 2 miss   
#> 3 captain
#> 4 frank  
#> 5 lady   
#> 6 colonel
#> # ... with 85 more rows
#> #
#> # Edge Data: 77 x 3
#>    from    to     n
#>   <int> <int> <int>
#> 1     1    28   287
#> 2     2    29   215
#> 3     3    30   170
#> # ... with 74 more rows
```

Note how `tidygraph` handles network data, the main `tbl_graph` object splits a network into two data frames: **Node data** and **Edge data**   



```r
ggraph(bigram_graph, layout = "fr") + 
  geom_edge_link() + 
  geom_node_point() + 
  geom_node_text(aes(label = name), vjust = 1, hjust = 1)
```

<img src="relationship-between-words_files/figure-html/unnamed-chunk-14-1.png" width="1152" />

We see that salutations such as “miss”, “lady”, “sir”, “and”colonel" are common centers of nodes, which are often followed by names. We also see pairs or triplets along the outside that form common short phrases (“half hour”, “thousand pounds”, or “short time/pause”).    

Note that this is a visualization of a Markov chain, a common model in text processing, where the choice of a word only depends on its previous word. In this case, a random generator following this model might spit out “dear”, then “sir”, then “william/walter/thomas/thomas’s”, by following each word to the most common words that follow it. 

A polished graph:  


```r
arrow <- grid::arrow(type = "closed", length = unit(.15, "inches"))

ggraph(bigram_graph, layout = "fr") + 
  geom_edge_link(aes(alpha = n), show.legend = F, 
                 arrow = arrow, end_cap = circle(0.07, "inches")) + 
  geom_node_point(color = "lightblue", size = 5) + 
  geom_node_text(aes(label = name), vjust = 1, hjust = 1)
```

<img src="relationship-between-words_files/figure-html/unnamed-chunk-15-1.png" width="1152" style="display: block; margin: auto;" />





### Visualizing  "friends"  

Here I deviate from the original text, where Julia and David analyzed King James Version of the Bible. However, I have collected the transcripts of the famous TV series, friends (season 1). Let's start a simple analysis first by loading the data 


```r
friends <- read_csv("data/friends_season_1.csv") %>% 
  select(-type)
glimpse(friends)
#> Observations: 5,974
#> Variables: 6
#> $ episode <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,...
#> $ person  <chr> "monica", "joey", "chandler", "phoebe", "phoebe", "monica",...
#> $ line    <chr> "there's nothing to tell! he's just some guyi work with!", ...
#> $ id      <chr> "0101", "0101", "0101", "0101", "0101", "0101", "0101", "01...
#> $ title   <chr> "The One Where Monica Gets a New Roomate (The Pilot-The Unc...
#> $ season  <chr> "01", "01", "01", "01", "01", "01", "01", "01", "01", "01",...
```

Retrieve a clean data frame with word counts (bigrams did not work very well)


```r
friends_bigram <- friends %>% 
  unnest_tokens(word, line, token = "ngrams", n = 2) %>%
  separate(word, into = c("word1", "word2"), sep = " ") %>% 
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word) %>% 
  filter(! (is.na(word1) | is.na(word2)))

friends_count <- friends_bigram %>% 
  count(word1, word2, sort = TRUE)

friends_count
#> # A tibble: 5,466 x 3
#>   word1 word2     n
#>   <chr> <chr> <int>
#> 1 hey   hey      36
#> 2 ow    ow       29
#> 3 la    la       27
#> 4 yeah  yeah     27
#> 5 wait  wait     17
#> 6 uh    huh      16
#> # ... with 5,460 more rows
```

Draw a network  


```r
friends_count %>% 
  filter(n > 3) %>%
  as_tbl_graph() %>% 
  ggraph(layout = "fr") + 
  geom_edge_link(aes(alpha = n), show.legend = FALSE,
                 arrow = arrow, end_cap = circle(0.07, "inches")) + 
  geom_node_point(color = "lightblue", size = 5) + 
  geom_node_text(aes(label = name), size = 4, vjust = 1, hjust = 1)
```

<img src="relationship-between-words_files/figure-html/unnamed-chunk-18-1.png" width="1152" style="display: block; margin: auto;" />

## Counting and correlating pairs of words with `widyr`  

> Tokenizing by n-gram is a useful way to explore pairs of adjacent words. However, we may also be interested in words that tend to co-occur within particular documents or particular chapters, even if they don’t occur next to each other.

For this reason, it is sometimes necessary to "cast" a tidy dataset into a wide matrix (such as a co-occurrence matrix), performs an operation such as a correlation on it, then re-tidies the result. This is when [`widyr`](https://github.com/dgrtwo/widyr) comes to the rescue, the workflow is shown in the book:  

<img src="images/widyr.jpg" width="512" style="display: block; margin: auto;" />

### Counting and correlating among sections  

We devide the book “Pride and Prejudice” into 10-line sections , as we did for Section \@ref(sentiment-analysis-with-inner-join) (80 lines). We may be interested in what words tend to appear within the same section.  



```r
austen_section_words <- austen_books() %>%
  filter(book == "Pride & Prejudice") %>%
  mutate(section = row_number() %/% 10) %>%
  filter(section > 0) %>%
  unnest_tokens(word, text) %>%
  filter(!word %in% stop_words$word)

austen_section_words
#> # A tibble: 37,240 x 3
#>   book              section word        
#>   <fct>               <dbl> <chr>       
#> 1 Pride & Prejudice       1 truth       
#> 2 Pride & Prejudice       1 universally 
#> 3 Pride & Prejudice       1 acknowledged
#> 4 Pride & Prejudice       1 single      
#> 5 Pride & Prejudice       1 possession  
#> 6 Pride & Prejudice       1 fortune     
#> # ... with 3.723e+04 more rows
```



`widyr::pairwise_counts()` counts the number of times each pair of *items* appear together within a group defined by "*feature*". In this case, it counts the number of times each pair of words appear together within a section, note it still returns a tidy data frame, although the underlying computation took place in a matrix form :  


```r
library(widyr)

austen_section_words %>% 
  pairwise_count(word, section, sort = TRUE)
#> # A tibble: 796,008 x 3
#>   item1     item2         n
#>   <chr>     <chr>     <dbl>
#> 1 darcy     elizabeth   144
#> 2 elizabeth darcy       144
#> 3 miss      elizabeth   110
#> 4 elizabeth miss        110
#> 5 elizabeth jane        106
#> 6 jane      elizabeth   106
#> # ... with 7.96e+05 more rows
```

We can easily find the words that most often occur with Darcy. Since `pairwise_count` records both the counts of `(word_A, word_B)` and `(word_B, word_B)`, it does not matter we `filter` at `item1` or `item2`  


```r
austen_section_words %>% 
  pairwise_count(word, section, sort = TRUE) %>% 
  filter(item1 == "darcy")
#> # A tibble: 2,930 x 3
#>   item1 item2         n
#>   <chr> <chr>     <dbl>
#> 1 darcy elizabeth   144
#> 2 darcy miss         92
#> 3 darcy bingley      86
#> 4 darcy jane         46
#> 5 darcy bennet       45
#> 6 darcy sister       45
#> # ... with 2,924 more rows
```

 
   
### Pairwise correlation

> Pairs like “Elizabeth” and “Darcy” are the most common co-occurring words, but that’s not particularly meaningful since they’re also the most common individual words. We may instead want to examine correlation among words, which indicates how often they appear together relative to how often they appear separately.   

In particular, we compute the $\phi$ coefficient. Introduced by Karl Pearson, this measure is similar to the Pearson correlation coefficient in its interpretation. In fact, a Pearson correlation coefficient estimated for two binary variables will return the $\phi$ coefficient. The phi coefficient is related to the chi-squared statistic for a 2 × 2 contingency table 

$$
\phi = \sqrt{\frac{\chi^2}{n}}
$$

where $n$ denotes sample size. In the case of pairwise counts, $\phi$ is calculated by 

<img src="images/phi.png" width="120%" style="display: block; margin: auto;" />


$$
\phi = \frac{n_{11}n_{00} - n_{10}n_{01}}{\sqrt{n_{1·}n_{0·}n_{·1}n_{·0}}}
$$

We see, from the above quation, that $\phi$ is "standarized" by individual counts, so various word pair with different individual frequency can be compared to each other:  

The computation of $\phi$ can be simply done by `pairwise_cor` (other choice of correlation coefficients specified by `method`). The procedure can be somewhat computationally expensive, so we filter out uncommon words


```r
word_cors <- austen_section_words %>% 
  add_count(word) %>% 
  filter(n >= 20) %>% 
  select(-n) %>%
  pairwise_cor(word, section, sort = TRUE)

word_cors
#> # A tibble: 154,842 x 3
#>   item1    item2    correlation
#>   <chr>    <chr>          <dbl>
#> 1 bourgh   de             0.951
#> 2 de       bourgh         0.951
#> 3 pounds   thousand       0.701
#> 4 thousand pounds         0.701
#> 5 william  sir            0.664
#> 6 sir      william        0.664
#> # ... with 1.548e+05 more rows
```

Which word is most correlated with "lady"?  


```r
word_cors %>% 
  filter(item1 == "lady")
#> # A tibble: 393 x 3
#>   item1 item2     correlation
#>   <chr> <chr>           <dbl>
#> 1 lady  catherine       0.663
#> 2 lady  de              0.283
#> 3 lady  bourgh          0.254
#> 4 lady  ladyship        0.227
#> 5 lady  lucas           0.198
#> 6 lady  collins         0.176
#> # ... with 387 more rows
```

This lets us pick particular interesting words and find the other words most associated with them  


```r
word_cors %>%
  filter(item1 %in% c("elizabeth", "pounds", "married", "pride")) %>%
  group_by(item1) %>%
  top_n(6) %>%
  ungroup() %>%
  facet_bar(y = item2, x = correlation, by = item1)
```

<img src="relationship-between-words_files/figure-html/unnamed-chunk-26-1.png" width="960" style="display: block; margin: auto;" />

How about a network visualization to see the overall correlation pattern? 


```r
word_cors %>%
  filter(correlation > .15) %>%
  as_tbl_graph() %>%
  ggraph(layout = "fr") +
  geom_edge_link(aes(edge_alpha = correlation), show.legend = FALSE) +
  geom_node_point(color = "lightblue", size = 5) +
  geom_node_text(aes(label = name), repel = TRUE)
```

<img src="relationship-between-words_files/figure-html/unnamed-chunk-27-1.png" width="960" style="display: block; margin: auto;" />


Note that unlike the bigram analysis, the relationships here are **symmetrical, rather than directional** (there are no arrows). We can also see that while pairings of names and titles that dominated bigram pairings are common, such as “colonel/fitzwilliam”, we can also see pairings of words that appear close to each other, such as “walk” and “park”, or “dance” and “ball”.
