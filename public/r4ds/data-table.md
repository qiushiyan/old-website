

   



# data.table  {#data-table}



**data.table**[@R-data.table]

https://rdatatable.gitlab.io/data.table/  

https://m-clark.github.io/data-processing-and-visualization/data_table.html   

<center>
<img src="images/22.png" width="80%" style="display: block; margin: auto;" />
</center>


```r
library(data.table)
```



```r
mtcars_dt <- as.data.table(mtcars) 
mtcars_dt
#>      mpg cyl  disp  hp drat   wt qsec vs am gear carb
#>  1: 21.0   6 160.0 110 3.90 2.62 16.5  0  1    4    4
#>  2: 21.0   6 160.0 110 3.90 2.88 17.0  0  1    4    4
#>  3: 22.8   4 108.0  93 3.85 2.32 18.6  1  1    4    1
#>  4: 21.4   6 258.0 110 3.08 3.21 19.4  1  0    3    1
#>  5: 18.7   8 360.0 175 3.15 3.44 17.0  0  0    3    2
#>  6: 18.1   6 225.0 105 2.76 3.46 20.2  1  0    3    1
#>  7: 14.3   8 360.0 245 3.21 3.57 15.8  0  0    3    4
#>  8: 24.4   4 146.7  62 3.69 3.19 20.0  1  0    4    2
#>  9: 22.8   4 140.8  95 3.92 3.15 22.9  1  0    4    2
#> 10: 19.2   6 167.6 123 3.92 3.44 18.3  1  0    4    4
#> 11: 17.8   6 167.6 123 3.92 3.44 18.9  1  0    4    4
#> 12: 16.4   8 275.8 180 3.07 4.07 17.4  0  0    3    3
#> 13: 17.3   8 275.8 180 3.07 3.73 17.6  0  0    3    3
#> 14: 15.2   8 275.8 180 3.07 3.78 18.0  0  0    3    3
#> 15: 10.4   8 472.0 205 2.93 5.25 18.0  0  0    3    4
#> 16: 10.4   8 460.0 215 3.00 5.42 17.8  0  0    3    4
#> 17: 14.7   8 440.0 230 3.23 5.34 17.4  0  0    3    4
#> 18: 32.4   4  78.7  66 4.08 2.20 19.5  1  1    4    1
#> 19: 30.4   4  75.7  52 4.93 1.61 18.5  1  1    4    2
#> 20: 33.9   4  71.1  65 4.22 1.83 19.9  1  1    4    1
#> 21: 21.5   4 120.1  97 3.70 2.46 20.0  1  0    3    1
#> 22: 15.5   8 318.0 150 2.76 3.52 16.9  0  0    3    2
#> 23: 15.2   8 304.0 150 3.15 3.44 17.3  0  0    3    2
#> 24: 13.3   8 350.0 245 3.73 3.84 15.4  0  0    3    4
#> 25: 19.2   8 400.0 175 3.08 3.85 17.1  0  0    3    2
#> 26: 27.3   4  79.0  66 4.08 1.94 18.9  1  1    4    1
#> 27: 26.0   4 120.3  91 4.43 2.14 16.7  0  1    5    2
#> 28: 30.4   4  95.1 113 3.77 1.51 16.9  1  1    5    2
#> 29: 15.8   8 351.0 264 4.22 3.17 14.5  0  1    5    4
#> 30: 19.7   6 145.0 175 3.62 2.77 15.5  0  1    5    6
#> 31: 15.0   8 301.0 335 3.54 3.57 14.6  0  1    5    8
#> 32: 21.4   4 121.0 109 4.11 2.78 18.6  1  1    4    2
#>      mpg cyl  disp  hp drat   wt qsec vs am gear carb
```


```r
class(mtcars_dt)
#> [1] "data.table" "data.frame"
```


## Introduction {#data-table-intro}




## dtplyr  

https://dtplyr.tidyverse.org/  


## maditr  

https://github.com/gdemin/maditr  


## tidyfast  

https://github.com/TysonStanley/tidyfast  

## disk.frame  

https://diskframe.com/  

https://www.youtube.com/watch?v=3XMTyi_H4q4




