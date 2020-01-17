

# rowwise operation  



## do() + rowwise()


```r
do(mtcars, head(., 2))
#>               mpg cyl disp  hp drat   wt qsec vs am gear carb
#> Mazda RX4      21   6  160 110  3.9 2.62 16.5  0  1    4    4
#> Mazda RX4 Wag  21   6  160 110  3.9 2.88 17.0  0  1    4    4
```




```r
do(mtcars, filter(., cyl > 6))
#>     mpg cyl disp  hp drat   wt qsec vs am gear carb
#> 1  18.7   8  360 175 3.15 3.44 17.0  0  0    3    2
#> 2  14.3   8  360 245 3.21 3.57 15.8  0  0    3    4
#> 3  16.4   8  276 180 3.07 4.07 17.4  0  0    3    3
#> 4  17.3   8  276 180 3.07 3.73 17.6  0  0    3    3
#> 5  15.2   8  276 180 3.07 3.78 18.0  0  0    3    3
#> 6  10.4   8  472 205 2.93 5.25 18.0  0  0    3    4
#> 7  10.4   8  460 215 3.00 5.42 17.8  0  0    3    4
#> 8  14.7   8  440 230 3.23 5.34 17.4  0  0    3    4
#> 9  15.5   8  318 150 2.76 3.52 16.9  0  0    3    2
#> 10 15.2   8  304 150 3.15 3.44 17.3  0  0    3    2
#> 11 13.3   8  350 245 3.73 3.84 15.4  0  0    3    4
#> 12 19.2   8  400 175 3.08 3.85 17.1  0  0    3    2
#> 13 15.8   8  351 264 4.22 3.17 14.5  0  1    5    4
#> 14 15.0   8  301 335 3.54 3.57 14.6  0  1    5    8
```


```r
by_cyl <- group_by(mtcars, cyl)
do(by_cyl, head(., 2))
#> # A tibble: 6 x 11
#> # Groups:   cyl [3]
#>     mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
#>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1  22.8     4  108     93  3.85  2.32  18.6     1     1     4     1
#> 2  24.4     4  147.    62  3.69  3.19  20       1     0     4     2
#> 3  21       6  160    110  3.9   2.62  16.5     0     1     4     4
#> 4  21       6  160    110  3.9   2.88  17.0     0     1     4     4
#> 5  18.7     8  360    175  3.15  3.44  17.0     0     0     3     2
#> 6  14.3     8  360    245  3.21  3.57  15.8     0     0     3     4
```



```r
models <- by_cyl %>% 
  do(mod = lm(mpg ~ disp, data = .))

models
#> Source: local data frame [3 x 2]
#> Groups: <by row>
#> 
#> # A tibble: 3 x 2
#>     cyl mod   
#> * <dbl> <list>
#> 1     4 <lm>  
#> 2     6 <lm>  
#> 3     8 <lm>
```


```r
models %>% do(data.frame(
  var = names(coef(.$mod)),
  coef(summary(.$mod)))
)
#> Source: local data frame [6 x 5]
#> Groups: <by row>
#> 
#> # A tibble: 6 x 5
#>   var         Estimate Std..Error t.value   Pr...t..
#> * <fct>          <dbl>      <dbl>   <dbl>      <dbl>
#> 1 (Intercept) 40.9        3.59     11.4   0.00000120
#> 2 disp        -0.135      0.0332   -4.07  0.00278   
#> 3 (Intercept) 19.1        2.91      6.55  0.00124   
#> 4 disp         0.00361    0.0156    0.232 0.826     
#> 5 (Intercept) 22.0        3.35      6.59  0.0000259 
#> 6 disp        -0.0196     0.00932  -2.11  0.0568
```

 

```r
by_cyl %>% 
  group_modify(~ broom::tidy(lm(mpg ~ disp, data = .)))
#> # A tibble: 6 x 6
#> # Groups:   cyl [3]
#>     cyl term        estimate std.error statistic    p.value
#>   <dbl> <chr>          <dbl>     <dbl>     <dbl>      <dbl>
#> 1     4 (Intercept) 40.9       3.59       11.4   0.00000120
#> 2     4 disp        -0.135     0.0332     -4.07  0.00278   
#> 3     6 (Intercept) 19.1       2.91        6.55  0.00124   
#> 4     6 disp         0.00361   0.0156      0.232 0.826     
#> 5     8 (Intercept) 22.0       3.35        6.59  0.0000259 
#> 6     8 disp        -0.0196    0.00932    -2.11  0.0568
```


```r
df <- expand.grid(x = 1:3, y = 3:1)
df_done <- df %>% 
  rowwise() %>% 
  do(i = seq(.$x, .$y))
df_done
#> Source: local data frame [9 x 1]
#> Groups: <by row>
#> 
#> # A tibble: 9 x 1
#>   i        
#> * <list>   
#> 1 <int [3]>
#> 2 <int [2]>
#> 3 <int [1]>
#> 4 <int [2]>
#> 5 <int [1]>
#> 6 <int [2]>
#> # ... with 3 more rows
```


```r
df_done %>% 
  summarise(n = length(i))
#> # A tibble: 9 x 1
#>       n
#>   <int>
#> 1     3
#> 2     2
#> 3     1
#> 4     2
#> 5     1
#> 6     2
#> # ... with 3 more rows
```



## rap

see https://github.com/romainfrancois/rap

```r
# devtools::install_github("romainfrancois/rap")
```


```r
library(rap)
```



```r
tbl <- tibble(cyl_threshold = c(4, 6, 8), mpg_threshold = c(30, 25, 20)) 
tbl
#> # A tibble: 3 x 2
#>   cyl_threshold mpg_threshold
#>           <dbl>         <dbl>
#> 1             4            30
#> 2             6            25
#> 3             8            20
```


```r
tbl %>% 
  rap(x = ~ filter(mtcars, cyl == cyl_threshold, mpg < mpg_threshold))
#> # A tibble: 3 x 3
#>   cyl_threshold mpg_threshold x                  
#>           <dbl>         <dbl> <list>             
#> 1             4            30 <df[,11] [7 x 11]> 
#> 2             6            25 <df[,11] [7 x 11]> 
#> 3             8            20 <df[,11] [14 x 11]>
```

