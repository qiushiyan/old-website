
# (PART) Text Mining with R {-}

# Tidy text format  



A "tidy" text format is defined as a per-token-per row data frame. This one-token-per-row structure is in contrast to the ways text is often stored in current analyses, perhaps as strings or in a document-term matrix (Chapter \@ref(converting-to-and-from-non-tidy-formats)). For tidy text mining, the token that is stored in each row is most often a single word, but can also be an n-gram, sentence, or paragraph. In the tidytext package, we provide functionality to tokenize by commonly used units of text like these and convert to a one-term-per-row format. 

## The `unnest_tokens()` function


```r
library(janeaustenr)
```


```r
austen_books()
#> # A tibble: 73,422 x 2
#>   text                    book               
#> * <chr>                   <fct>              
#> 1 "SENSE AND SENSIBILITY" Sense & Sensibility
#> 2 ""                      Sense & Sensibility
#> 3 "by Jane Austen"        Sense & Sensibility
#> 4 ""                      Sense & Sensibility
#> 5 "(1811)"                Sense & Sensibility
#> 6 ""                      Sense & Sensibility
#> # ... with 7.342e+04 more rows
```



```r
original_books <- austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number(),
         chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]",
                                                 ignore_case = TRUE)))) %>%
  ungroup()

original_books
#> # A tibble: 73,422 x 4
#>   text                    book                linenumber chapter
#>   <chr>                   <fct>                    <int>   <int>
#> 1 "SENSE AND SENSIBILITY" Sense & Sensibility          1       0
#> 2 ""                      Sense & Sensibility          2       0
#> 3 "by Jane Austen"        Sense & Sensibility          3       0
#> 4 ""                      Sense & Sensibility          4       0
#> 5 "(1811)"                Sense & Sensibility          5       0
#> 6 ""                      Sense & Sensibility          6       0
#> # ... with 7.342e+04 more rows
```



```r
original_books %>%
  unnest_tokens(word, text)
#> # A tibble: 725,055 x 4
#>   book                linenumber chapter word       
#>   <fct>                    <int>   <int> <chr>      
#> 1 Sense & Sensibility          1       0 sense      
#> 2 Sense & Sensibility          1       0 and        
#> 3 Sense & Sensibility          1       0 sensibility
#> 4 Sense & Sensibility          3       0 by         
#> 5 Sense & Sensibility          3       0 jane       
#> 6 Sense & Sensibility          3       0 austen     
#> # ... with 7.25e+05 more rows
```


```r
stop_words 
#> # A tibble: 1,149 x 2
#>   word      lexicon
#>   <chr>     <chr>  
#> 1 a         SMART  
#> 2 a's       SMART  
#> 3 able      SMART  
#> 4 about     SMART  
#> 5 above     SMART  
#> 6 according SMART  
#> # ... with 1,143 more rows

tidy_books <- original_books %>%
  unnest_tokens(word, text) %>% 
  anti_join(stop_words)

tidy_books
#> # A tibble: 217,609 x 4
#>   book                linenumber chapter word       
#>   <fct>                    <int>   <int> <chr>      
#> 1 Sense & Sensibility          1       0 sense      
#> 2 Sense & Sensibility          1       0 sensibility
#> 3 Sense & Sensibility          3       0 jane       
#> 4 Sense & Sensibility          3       0 austen     
#> 5 Sense & Sensibility          5       0 1811       
#> 6 Sense & Sensibility         10       1 chapter    
#> # ... with 2.176e+05 more rows
```


## The `gutenbergr` package   


```r
library(gutenbergr)
```

The gutenbergr package provides access to the public domain works from the Project Gutenberg collection. The package includes tools both for downloading books (stripping out the unhelpful header/footer information), and a complete dataset of Project Gutenberg metadata that can be used to find works of interest. In this book, we will mostly use the function `gutenberg_download()` that downloads one or more works from Project Gutenberg by ID.  

The dataset gutenberg_metadata contains information about each work, pairing Gutenberg ID with title, author, language, etc:  


```r
gutenberg_metadata
#> # A tibble: 51,997 x 8
#>   gutenberg_id title author gutenberg_autho~ language gutenberg_books~ rights
#>          <int> <chr> <chr>             <int> <chr>    <chr>            <chr> 
#> 1            0  <NA> <NA>                 NA en       <NA>             Publi~
#> 2            1 "The~ Jeffe~             1638 en       United States L~ Publi~
#> 3            2 "The~ Unite~                1 en       American Revolu~ Publi~
#> 4            3 "Joh~ Kenne~             1666 en       <NA>             Publi~
#> 5            4 "Lin~ Linco~                3 en       US Civil War     Publi~
#> 6            5 "The~ Unite~                1 en       American Revolu~ Publi~
#> # ... with 5.199e+04 more rows, and 1 more variable: has_text <lgl>
```




For example, you could find the Gutenberg ID of Wuthering Heights by doing:  


```r
gutenberg_metadata %>%
  filter(title == "Wuthering Heights")
#> # A tibble: 1 x 8
#>   gutenberg_id title author gutenberg_autho~ language gutenberg_books~ rights
#>          <int> <chr> <chr>             <int> <chr>    <chr>            <chr> 
#> 1          768 Wuth~ Bront~              405 en       Gothic Fiction/~ Publi~
#> # ... with 1 more variable: has_text <lgl>

gutenberg_download(768)
#> # A tibble: 12,085 x 2
#>   gutenberg_id text               
#>          <int> <chr>              
#> 1          768 "WUTHERING HEIGHTS"
#> 2          768 ""                 
#> 3          768 ""                 
#> 4          768 "CHAPTER I"        
#> 5          768 ""                 
#> 6          768 ""                 
#> # ... with 1.208e+04 more rows
```


In many analyses, you may want to filter just for English works, avoid duplicates, and include only books that have text that can be downloaded. The `gutenberg_works()` function does this pre-filtering. It also allows you to perform filtering as an argument:


```r
gutenberg_works(author == "Austen, Jane")
#> # A tibble: 10 x 8
#>   gutenberg_id title author gutenberg_autho~ language gutenberg_books~ rights
#>          <int> <chr> <chr>             <int> <chr>    <chr>            <chr> 
#> 1          105 Pers~ Auste~               68 en       <NA>             Publi~
#> 2          121 Nort~ Auste~               68 en       Gothic Fiction   Publi~
#> 3          141 Mans~ Auste~               68 en       <NA>             Publi~
#> 4          158 Emma  Auste~               68 en       <NA>             Publi~
#> 5          161 Sens~ Auste~               68 en       <NA>             Publi~
#> 6          946 Lady~ Auste~               68 en       <NA>             Publi~
#> # ... with 4 more rows, and 1 more variable: has_text <lgl>
```


## Compare word frequency  

As a common task in text analysis, compariosn of word frequencies is often employed as a tool to extract linguistic characteristics. A rule of thumb is to compare word **proportions** instead of raw counts.  

In this example, we compare novels of Jane Austen, H.G. Wells, and the Bronte Sisters. 


```r
austen <- austen_books() %>% 
  select(-book) %>% 
  mutate(author = "Jane Austen")
bronte <- gutenberg_download(c(1260, 768, 969, 9182, 767)) %>%
  select(-gutenberg_id) %>% 
  mutate(author = "Brontë Sisters")
hgwells <- gutenberg_download(c(35, 36, 5230, 159)) %>% 
  select(-gutenberg_id) %>% 
  mutate(author = "H.G. Wells")

tidy_book <- function(author) {
  author %>% 
    unnest_tokens(word, text) %>% 
    anti_join(stop_words)
}



books <- bind_rows(tidy_book(austen),
          tidy_book(bronte),
          tidy_book(hgwells)) %>% 
  mutate(word = str_extract(word, "[:alpha:]+")) %>% 
  count(author, word, sort = TRUE)
```



```r
books
#> # A tibble: 46,956 x 3
#>   author         word       n
#>   <chr>          <chr>  <int>
#> 1 Jane Austen    miss    1860
#> 2 Jane Austen    time    1339
#> 3 Brontë Sisters time    1065
#> 4 Jane Austen    fanny    977
#> 5 Jane Austen    emma     866
#> 6 Jane Austen    sister   865
#> # ... with 4.695e+04 more rows
```

Now, our goal is to use Jane Austen as a reference to which the other two authors are compared to in terms of word frequency. The data manipulation requires a bit trick, after computing proportions of word usage, we first `pivot_wider` three authors altogether, an then `pivot_wider` the other two authors back.  


```r
comparison_df <- books %>%
  add_count(author, wt = n, name = "total_word") %>% 
  mutate(proportion = n / total_word) %>% 
  select(-total_word, -n) %>% 
  pivot_wider(names_from = author, values_from = proportion, 
              values_fill = list(proportion = 0)) %>%
  pivot_longer(3:4, names_to = "other", values_to = "proportion")

comparison_df
#> # A tibble: 56,002 x 4
#>   word  `Jane Austen` other          proportion
#>   <chr>         <dbl> <chr>               <dbl>
#> 1 miss        0.00855 Brontë Sisters  0.00342  
#> 2 miss        0.00855 H.G. Wells      0.000120 
#> 3 time        0.00615 Brontë Sisters  0.00424  
#> 4 time        0.00615 H.G. Wells      0.00682  
#> 5 fanny       0.00449 Brontë Sisters  0.0000438
#> 6 fanny       0.00449 H.G. Wells      0        
#> # ... with 5.6e+04 more rows
```



```r
library(scales)

comparison_df %>% 
  filter(proportion > 1 / 1e5) %>% 
  ggplot(aes(proportion, `Jane Austen`)) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(aes(color = abs(`Jane Austen` - proportion)),
              alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) + 
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) + 
  scale_color_gradient(limits = c(0, 0.001), low = "darkslategray4", high = "gray75") + 
  facet_wrap(~ other) + 
  guides(color = FALSE)
```

<img src="tidytextformat_files/figure-html/unnamed-chunk-14-1.png" width="960" style="display: block; margin: auto;" />

Words that are close to the line in these plots have similar frequencies in both sets of texts, for example, in both Austen and Brontë texts (“miss”, “time”, “day” at the upper frequency end) or in both Austen and Wells texts (“time”, “day”, “brother” at the high frequency end). Words that are far from the line are words that are found more in one set of texts than another. For example, in the Austen-Brontë panel, words like “elizabeth”, “emma”, and “fanny” (all proper nouns) are found in Austen’s texts but not much in the Brontë texts, while words like “arthur” and “dog” are found in the Brontë texts but not the Austen texts. In comparing H.G. Wells with Jane Austen, Wells uses words like “beast”, “guns”, “feet”, and “black” that Austen does not, while Austen uses words like “family”, “friend”, “letter”, and “dear” that Wells does not.

Notice that  the words in the Austen-Brontë panel are closer to the zero-slope line than in the Austen-Wells panel. Also notice that the words extend to lower frequencies in the Austen-Brontë panel; there is empty space in the Austen-Wells panel at low frequency. These characteristics indicate that Austen and the Brontë sisters use more similar words than Austen and H.G. Wells. Also, we see that not all the words are found in all three sets of texts and there are fewer data points in the panel for Austen and H.G. Wells.

Furhter, we can conduct a simple correlation test


```r
cor.test(data = filter(comparison_df, other == "Brontë Sisters"),
         ~ proportion + `Jane Austen`)
#> 
#> 	Pearson's product-moment correlation
#> 
#> data:  proportion and Jane Austen
#> t = 169, df = 27999, p-value <0.0000000000000002
#> alternative hypothesis: true correlation is not equal to 0
#> 95 percent confidence interval:
#>  0.705 0.716
#> sample estimates:
#>   cor 
#> 0.711

cor.test(data = filter(comparison_df, other == "H.G. Wells"),
         ~ proportion + `Jane Austen`)
#> 
#> 	Pearson's product-moment correlation
#> 
#> data:  proportion and Jane Austen
#> t = 72, df = 27999, p-value <0.0000000000000002
#> alternative hypothesis: true correlation is not equal to 0
#> 95 percent confidence interval:
#>  0.383 0.403
#> sample estimates:
#>   cor 
#> 0.393
```


## Other tokenization methods  

`unnest_tokens` supports other ways to split a column into tokens. 


```r
text <- c("This is, my bookdown book.",
          "Chapter 1: Preface\n", 
          "Thanks for \n reading this book\n",
          "Chapter 2: Introduction\n",
          "Chapter 3: Methods\n",
          "I demonstrate all of the methods here,",
          "well, not all actually.\n\n",
          "Chapter 4: Discussion\n",
          "blablabla,",
          "blablabla,",
          "blablabla.")
df <- tibble(text = text)
cat(df$text)
#> This is, my bookdown book. Chapter 1: Preface
#>  Thanks for 
#>  reading this book
#>  Chapter 2: Introduction
#>  Chapter 3: Methods
#>  I demonstrate all of the methods here, well, not all actually.
#> 
#>  Chapter 4: Discussion
#>  blablabla, blablabla, blablabla.
```





```r
# lines
df %>% unnest_tokens(line, text, token = "lines")
#> # A tibble: 12 x 1
#>   line                        
#>   <chr>                       
#> 1 "this is, my bookdown book."
#> 2 "chapter 1: preface"        
#> 3 "thanks for "               
#> 4 " reading this book"        
#> 5 "chapter 2: introduction"   
#> 6 "chapter 3: methods"        
#> # ... with 6 more rows
# sentences, split by period
df %>% unnest_tokens(sentences, text, token = "sentences")
#> # A tibble: 3 x 1
#>   sentences                                                                     
#>   <chr>                                                                         
#> 1 this is, my bookdown book.                                                    
#> 2 chapter 1: preface  thanks for   reading this book  chapter 2: introduction  ~
#> 3 chapter 4: discussion  blablabla, blablabla, blablabla.
# paragraphs
df %>% unnest_tokens(paragraphs, text, token = "paragraphs")
#> # A tibble: 7 x 1
#>   paragraphs                                                      
#>   <chr>                                                           
#> 1 "this is, my bookdown book. chapter 1: preface"                 
#> 2 "thanks for   reading this book"                                
#> 3 "chapter 2: introduction"                                       
#> 4 "chapter 3: methods"                                            
#> 5 "i demonstrate all of the methods here, well, not all actually."
#> 6 " chapter 4: discussion"                                        
#> # ... with 1 more row
```



```r
# split into characters or multiple characters 
df %>% unnest_tokens(character, text, token = "characters")
#> # A tibble: 188 x 1
#>   character
#>   <chr>    
#> 1 t        
#> 2 h        
#> 3 i        
#> 4 s        
#> 5 i        
#> 6 s        
#> # ... with 182 more rows
df %>% unnest_tokens(characters, text, token = "character_shingles", n = 4)
#> # A tibble: 185 x 1
#>   characters
#>   <chr>     
#> 1 this      
#> 2 hisi      
#> 3 isis      
#> 4 sism      
#> 5 ismy      
#> 6 smyb      
#> # ... with 179 more rows
```


```r
# split by regex
df %>% 
  unnest_tokens(chapter, text, token = "regex", pattern = "Chapter \\d:")
#> # A tibble: 5 x 1
#>   chapter                                                                       
#>   <chr>                                                                         
#> 1 "this is, my bookdown book.\n"                                                
#> 2 " preface\n\nthanks for \n reading this book\n\n"                             
#> 3 " introduction\n\n"                                                           
#> 4 " methods\n\ni demonstrate all of the methods here,\nwell, not all actually.\~
#> 5 " discussion\n\nblablabla,\nblablabla,\nblablabla."
```
