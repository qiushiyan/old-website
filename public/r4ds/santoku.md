

# santoku    

https://hughjonesd.github.io/santoku/tutorials/00-visualintroduction.html


```r
# devtools::install_github("hughjonesd/santoku")
# library(tidyverse) (load tidyverse before santoku to avoid conflicts)
library(santoku)
```

`cut()` in base R  


```r
x <- rnorm(100)
cut(x, 5) %>% table()  # 5 equal intervals
#> .
#>  (-2.88,-1.62] (-1.62,-0.368] (-0.368,0.884]   (0.884,2.14]     (2.14,3.4] 
#>              5             25             53             16              1
cut(x, -3:3) %>% table()
#> .
#> (-3,-2] (-2,-1]  (-1,0]   (0,1]   (1,2]   (2,3] 
#>       3      15      27      38      16       0
```

`ntile()` in dplyr:  


```r
ntile(x, 5) %>% table()
#> .
#>  1  2  3  4  5 
#> 20 20 20 20 20
```




`chop()`


```r
chopped <- chop(x, breaks = -5:5)

chopped %>% table()
#> .
#> [-3, -2) [-2, -1)  [-1, 0)   [0, 1)   [1, 2)   [3, 4) 
#>        3       15       27       38       16        1

# chop() returns a factor
tibble(x, chopped)
#> # A tibble: 100 x 2
#>         x chopped 
#>     <dbl> <fct>   
#> 1  0.788  [0, 1)  
#> 2 -0.422  [-1, 0) 
#> 3  0.0569 [0, 1)  
#> 4  0.711  [0, 1)  
#> 5 -1.59   [-2, -1)
#> 6  0.597  [0, 1)  
#> # ... with 94 more rows
```

If data is beyond the limits of `breaks`, they will be extended automatically, unless `extend = FALSE`, and values beyond the bounds will be converted to `NA`:  


```r
chopped <- chop(x, breaks = -1:1, extend = FALSE)
tibble(x, chopped)
#> # A tibble: 100 x 2
#>         x chopped
#>     <dbl> <fct>  
#> 1  0.788  [0, 1] 
#> 2 -0.422  [-1, 0)
#> 3  0.0569 [0, 1] 
#> 4  0.711  [0, 1] 
#> 5 -1.59   <NA>   
#> 6  0.597  [0, 1] 
#> # ... with 94 more rows
```

To chop a single number into a separate category, put the number twice in `breaks`:


```r
x_zeros <- x 
x_zeros[1:5] <- 0

chopped <- chop(x_zeros, c(-1, 0, 0, 1))
tibble(x, chopped)
#> # A tibble: 100 x 2
#>         x chopped
#>     <dbl> <fct>  
#> 1  0.788  {0}    
#> 2 -0.422  {0}    
#> 3  0.0569 {0}    
#> 4  0.711  {0}    
#> 5 -1.59   {0}    
#> 6  0.597  (0, 1] 
#> # ... with 94 more rows
```

To quickly produce a table of chopped data, use `tab()`:  


```r
tab(x, breaks = -3:3)
#> x
#>  [-3, -2)  [-2, -1)   [-1, 0)    [0, 1)    [1, 2) (3, 3.39] 
#>         3        15        27        38        16         1
```

