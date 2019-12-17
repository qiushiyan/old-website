


# (PART) Exploring and Wrangling {-}  


# skimr

**skimr**[@R-skimr] 是由 [rOpenSci project](https://github.com/ropensci) 开发的用于探索性数据分析的包，可以看作增强版的 `summary()`，根据不同的列类型返回整洁有用的统计量。如：  





```r
library(skimr)
skim(iris)
#> -- Data Summary ------------------------
#>                            Values
#> Name                       iris  
#> Number of rows             150   
#> Number of columns          5     
#> _______________________          
#> Column type frequency:           
#>   factor                   1     
#>   numeric                  4     
#> ________________________         
#> Group variables            None  
#> 
#> -- Variable type: factor -----------------------------------------------
#>   skim_variable n_missing complete_rate ordered n_unique
#> 1 Species               0             1 FALSE          3
#>   top_counts               
#> 1 set: 50, ver: 50, vir: 50
#> 
#> -- Variable type: numeric ----------------------------------------------
#>   skim_variable n_missing complete_rate  mean    sd    p0   p25   p50   p75
#> 1 Sepal.Length          0             1  5.84 0.828   4.3   5.1  5.8    6.4
#> 2 Sepal.Width           0             1  3.06 0.436   2     2.8  3      3.3
#> 3 Petal.Length          0             1  3.76 1.77    1     1.6  4.35   5.1
#> 4 Petal.Width           0             1  1.20 0.762   0.1   0.3  1.3    1.8
#>    p100 hist 
#> 1   7.9 <U+2586><U+2587><U+2587><U+2585><U+2582>
#> 2   4.4 <U+2581><U+2586><U+2587><U+2582><U+2581>
#> 3   6.9 <U+2587><U+2581><U+2586><U+2587><U+2582>
#> 4   2.5 <U+2587><U+2581><U+2587><U+2585><U+2583>
```

由于 `skim()` 的返回结果在 bookdown 里显示效果不太好，这里只给出一个最简单的例子，关于该包的具体使用可见 [Introduction to skimr](https://qiushi.netlify.com/post/introduction-to-skimr/)  
