


# data.table {#data-table}  

**data.table**[@R-data.table]

https://rdatatable.gitlab.io/data.table/  

https://m-clark.github.io/data-processing-and-visualization/data_table.html   



```r
library(data.table)
```


```r
dt <- data.table(x = rnorm(1000),
                 y = rnorm(1000))
dt
#>             x      y
#>    1:  0.7877 -0.274
#>    2: -0.4220  1.587
#>    3:  0.0569  0.446
#>    4:  0.7106  1.885
#>    5: -1.5875 -0.761
#>   ---               
#>  996:  0.2178  0.101
#>  997:  0.1257  1.300
#>  998:  0.4027 -0.512
#>  999:  1.6292  0.761
#> 1000:  1.3437 -0.174
```



```r
dt[, z := rnorm(1000)]
dt
#>             x      y       z
#>    1:  0.7877 -0.274  0.6987
#>    2: -0.4220  1.587  0.0828
#>    3:  0.0569  0.446 -0.9761
#>    4:  0.7106  1.885 -0.5814
#>    5: -1.5875 -0.761  0.5285
#>   ---                       
#>  996:  0.2178  0.101  1.4036
#>  997:  0.1257  1.300 -0.8953
#>  998:  0.4027 -0.512 -0.1449
#>  999:  1.6292  0.761  1.5657
#> 1000:  1.3437 -0.174  1.1179
```


```r
dt2 <- dt
dt[, z := NULL]

dt2
#>             x      y
#>    1:  0.7877 -0.274
#>    2: -0.4220  1.587
#>    3:  0.0569  0.446
#>    4:  0.7106  1.885
#>    5: -1.5875 -0.761
#>   ---               
#>  996:  0.2178  0.101
#>  997:  0.1257  1.300
#>  998:  0.4027 -0.512
#>  999:  1.6292  0.761
#> 1000:  1.3437 -0.174
```



## dtplyr  

https://dtplyr.tidyverse.org/  


## maditr  

https://github.com/gdemin/maditr  


## tidyfast  

https://github.com/TysonStanley/tidyfast  