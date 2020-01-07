


# Data Summary


## skimr 

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
#> -- Variable type: factor -----------------------------------------------------------------------------------------------
#>   skim_variable n_missing complete_rate ordered n_unique
#> 1 Species               0             1 FALSE          3
#>   top_counts               
#> 1 set: 50, ver: 50, vir: 50
#> 
#> -- Variable type: numeric ----------------------------------------------------------------------------------------------
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

## visdat 



```r
# install.packages("visdata")
library(visdat)
```

https://docs.ropensci.org/visdat/    


```r
vis_dat(ggplot2::diamonds)
```

<img src="summary_files/figure-html/unnamed-chunk-5-1.svg" width="80%" />

## summarytools  

由于很多 summarytools 中的函数往往直接生成 markdown 代码，为了在 rmarkdown 正确美观的呈现它们需要同时设置 summarytools 中和 knitr 中的一些全局选项：（详细可见[Recommendations for Using summarytools With Rmarkdown](https://cran.r-project.org/web/packages/summarytools/vignettes/Recommendations-rmarkdown.html#dfsummary)）。  


```r
library(summarytools)
```



```r
st_options(bootstrap.css     = FALSE,       # Already part of the theme so no need for it
           plain.ascii       = FALSE,       # One of the essential settings
           style             = "rmarkdown", # Idem.
           dfSummary.silent  = TRUE,        # Suppresses messages about temporary files
           footnote          = NA,          # Keeping the results minimalistic
           subtitle.emphasis = FALSE)       # For the vignette theme, this gives
                                            # much better results. Your mileage may vary.

st_css()  # This is a must; without it, expect odd layout, especially with dfSummary()
#> <style type="text/css">
#>  img {   background-color: transparent;   border: 0; }  .st-table td, .st-table th {   padding: 8px; }  .st-table > thead > tr {    background-color: #eeeeee; }  .st-cross-table td {   text-align: center; }  .st-descr-table td {   text-align: right; }  .st-small {   font-size: 13px; }  .st-small td, .st-small th {   padding: 8px; }  table.st-table th {   text-align: center; }  .st-small > thead > tr > th, .st-small > tbody > tr > th, .st-small > tfoot > tr > th, .st-small > thead > tr > td, .st-small > tbody > tr > td, .st-small > tfoot > tr > td {   padding-left: 12px;   padding-right: 12px; }  table.st-table > thead > tr {    background-color: #eeeeee; }   table.st-table td span {   display: block; }  .st-container {   width: 100%;   padding-right: 15px;   padding-left: 15px;   margin-right: auto;   margin-left: auto;   margin-top: 15px; }  .st-multiline {   white-space: pre; }  .st-table {     width: auto;     table-layout: auto;     margin-top: 20px;     margin-bottom: 20px;     max-width: 100%;     background-color: transparent;     border-collapse: collapse; }   .st-table > thead > tr > th, .st-table > tbody > tr > th, .st-table > tfoot > tr > th, .st-table > thead > tr > td, .st-table > tbody > tr > td, .st-table > tfoot > tr > td {   vertical-align: middle; }  .st-table-bordered {   border: 1px solid #bbbbbb; }  .st-table-bordered > thead > tr > th, .st-table-bordered > tbody > tr > th, .st-table-bordered > tfoot > tr > th, .st-table-bordered > thead > tr > td, .st-table-bordered > tbody > tr > td, .st-table-bordered > tfoot > tr > td {   border: 1px solid #cccccc; }  .st-table-bordered > thead > tr > th, .st-table-bordered > thead > tr > td, .st-table thead > tr > th {   border-bottom: none; }  .st-freq-table > thead > tr > th, .st-freq-table > tbody > tr > th, .st-freq-table > tfoot > tr > th, .st-freq-table > thead > tr > td, .st-freq-table > tbody > tr > td, .st-freq-table > tfoot > tr > td, .st-freq-table-nomiss > thead > tr > th, .st-freq-table-nomiss > tbody > tr > th, .st-freq-table-nomiss > tfoot > tr > th, .st-freq-table-nomiss > thead > tr > td, .st-freq-table-nomiss > tbody > tr > td, .st-freq-table-nomiss > tfoot > tr > td, .st-cross-table > thead > tr > th, .st-cross-table > tbody > tr > th, .st-cross-table > tfoot > tr > th, .st-cross-table > thead > tr > td, .st-cross-table > tbody > tr > td, .st-cross-table > tfoot > tr > td {   padding-left: 20px;   padding-right: 20px; }     .st-table-bordered > thead > tr > th, .st-table-bordered > tbody > tr > th, .st-table-bordered > thead > tr > td, .st-table-bordered > tbody > tr > td {   border: 1px solid #cccccc; }  .st-table-striped > tbody > tr:nth-of-type(odd) {   background-color: #ffffff; }  .st-table-striped > tbody > tr:nth-of-type(even) {   background-color: #f9f9f9; }   .st-descr-table > thead > tr > th, .st-descr-table > tbody > tr > th, .st-descr-table > tfoot > tr > th, .st-descr-table > thead > tr > td, .st-descr-table > tbody > tr > td, .st-descr-table > tfoot > tr > td {   padding-left: 24px;   padding-right: 24px;   word-wrap: break-word; }  .st-freq-table, .st-freq-table-nomiss, .st-cross-table {   border: medium none; }  .st-freq-table > thead > tr:nth-child(1) > th:nth-child(1), .st-cross-table > thead > tr:nth-child(1) > th:nth-child(1), .st-cross-table > thead > tr:nth-child(1) > th:nth-child(3) {   border: none;   background-color: #ffffff;   text-align: center; }  .st-protect-top-border {   border-top: 1px solid #cccccc !important; }  .st-ws-char {   display: inline;   color: #999999;   letter-spacing: 0.2em; } </style>
```




```r
library(knitr)
opts_chunk$set(comment = NA, 
               prompt = FALSE,
               results='asis',
               collapse = FALSE)
```

如果之前没有设置 `collpase = TRUE`, `collapse = FALSE` 不是必要的



### `freq`


```r
freq(iris$Species, plain.ascii = FALSE, style = "rmarkdown", headings = FALSE)

|         &nbsp; | Freq | % Valid | % Valid Cum. | % Total | % Total Cum. |
|---------------:|-----:|--------:|-------------:|--------:|-------------:|
|     **setosa** |   50 |   33.33 |        33.33 |   33.33 |        33.33 |
| **versicolor** |   50 |   33.33 |        66.67 |   33.33 |        66.67 |
|  **virginica** |   50 |   33.33 |       100.00 |   33.33 |       100.00 |
|     **\<NA\>** |    0 |         |              |    0.00 |       100.00 |
|      **Total** |  150 |  100.00 |       100.00 |  100.00 |       100.00 |
```



```r
freq(iris$Species, report.nas = FALSE, headings = FALSE)
#> 
#>                    Freq        %   % Cum.
#> ---------------- ------ -------- --------
#>           setosa     50    33.33    33.33
#>       versicolor     50    33.33    66.67
#>        virginica     50    33.33   100.00
#>            Total    150   100.00   100.00
```


```r
freq(iris$Species, report.nas = FALSE, totals = FALSE,
     cumul = FALSE, style = "rmarkdown", headings = FALSE)
#> 
#> |         &nbsp; | Freq |     % |
#> |---------------:|-----:|------:|
#> |     **setosa** |   50 | 33.33 |
#> | **versicolor** |   50 | 33.33 |
#> |  **virginica** |   50 | 33.33 |
```


### `descr()`  


```r
descr(iris)
#> Descriptive Statistics  
#> iris  
#> N: 150  
#> 
#>                     Petal.Length   Petal.Width   Sepal.Length   Sepal.Width
#> ----------------- -------------- ------------- -------------- -------------
#>              Mean           3.76          1.20           5.84          3.06
#>           Std.Dev           1.77          0.76           0.83          0.44
#>               Min           1.00          0.10           4.30          2.00
#>                Q1           1.60          0.30           5.10          2.80
#>            Median           4.35          1.30           5.80          3.00
#>                Q3           5.10          1.80           6.40          3.30
#>               Max           6.90          2.50           7.90          4.40
#>               MAD           1.85          1.04           1.04          0.44
#>               IQR           3.50          1.50           1.30          0.50
#>                CV           0.47          0.64           0.14          0.14
#>          Skewness          -0.27         -0.10           0.31          0.31
#>       SE.Skewness           0.20          0.20           0.20          0.20
#>          Kurtosis          -1.42         -1.36          -0.61          0.14
#>           N.Valid         150.00        150.00         150.00        150.00
#>         Pct.Valid         100.00        100.00         100.00        100.00
```

