

# (PART) Exploring and Wrangling {-}    



# data.table {#data-table}  

All C++ code chunks will be combined to the chunk below:



First we include the header `Rcpp.h`:


```cpp
#include <Rcpp.h>
```

Then we define a function:


```cpp
// [[Rcpp::export]]
int timesTwo(int x) {
  return x * 2;
}
```

**data.table**[@R-data.table]

https://rdatatable.gitlab.io/data.table/  

https://m-clark.github.io/data-processing-and-visualization/data_table.html   

<center>
<img src="images/22.png" width="80%" />
</center>


```r
library(data.table)
```



```r
y = list(id = 1:2, name = c("a", "b"))
x = as.data.table(y)
x
#>    id name
#> 1:  1    a
#> 2:  2    b
```


```r
class(x)
#> [1] "data.table" "data.frame"
```


## 基本使用 {#data-table-basics}



## dtplyr  

https://dtplyr.tidyverse.org/  


## maditr  

https://github.com/gdemin/maditr  


## tidyfast  

https://github.com/TysonStanley/tidyfast  

## disk.frame  

https://diskframe.com/  



```r
# install.packages("disk.frame")  
```

