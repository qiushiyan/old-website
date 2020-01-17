

# sjmisc  

https://strengejacke.github.io/sjmisc/articles/exploringdatasets.html  


```r
library(sjmisc)
```


```r
data(efc)
(efc <- efc %>% as_tibble())
#> # A tibble: 908 x 26
#>   c12hour e15relat e16sex e17age e42dep c82cop1 c83cop2 c84cop3 c85cop4 c86cop5
#>     <dbl>    <dbl>  <dbl>  <dbl>  <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
#> 1      16        2      2     83      3       3       2       2       2       1
#> 2     148        2      2     88      3       3       3       3       3       4
#> 3      70        1      2     82      3       2       2       1       4       1
#> 4     168        1      2     67      4       4       1       3       1       1
#> 5     168        2      2     84      4       3       2       1       2       2
#> 6      16        2      2     85      4       2       2       3       3       3
#> # ... with 902 more rows, and 16 more variables: c87cop6 <dbl>, c88cop7 <dbl>,
#> #   c89cop8 <dbl>, c90cop9 <dbl>, c160age <dbl>, c161sex <dbl>, c172code <dbl>,
#> #   c175empl <dbl>, barthtot <dbl>, neg_c_7 <dbl>, pos_v_4 <dbl>, quol_5 <dbl>,
#> #   resttotn <dbl>, tot_sc_e <dbl>, n4pstu <dbl>, nur_pst <dbl>
```

## `frq()` 和 `flat_table()` 一维和二维频数表


```r
efc %>%
  frq(c161sex)
#> 
#> carer's gender (c161sex) <numeric>
#> # total N=908  valid N=901  mean=1.76  sd=0.43
#> 
#>  val  label frq raw.prc valid.prc cum.prc
#>    1   Male 215   23.68      23.9    23.9
#>    2 Female 686   75.55      76.1   100.0
#>   NA   <NA>   7    0.77        NA      NA
```

```r
efc %>% 
  group_by(e42dep) %>% 
  frq(c161sex)
#> 
#> carer's gender (c161sex) <numeric>
#> # grouped by: independent
#> # total N=66  valid N=66  mean=1.73  sd=0.45
#> 
#>  val  label frq raw.prc valid.prc cum.prc
#>    1   Male  18    27.3      27.3    27.3
#>    2 Female  48    72.7      72.7   100.0
#>   NA   <NA>   0     0.0        NA      NA
#> 
#> 
#> carer's gender (c161sex) <numeric>
#> # grouped by: slightly dependent
#> # total N=225  valid N=224  mean=1.76  sd=0.43
#> 
#>  val  label frq raw.prc valid.prc cum.prc
#>    1   Male  54   24.00      24.1    24.1
#>    2 Female 170   75.56      75.9   100.0
#>   NA   <NA>   1    0.44        NA      NA
#> 
#> 
#> carer's gender (c161sex) <numeric>
#> # grouped by: moderately dependent
#> # total N=306  valid N=306  mean=1.74  sd=0.44
#> 
#>  val  label frq raw.prc valid.prc cum.prc
#>    1   Male  80    26.1      26.1    26.1
#>    2 Female 226    73.9      73.9   100.0
#>   NA   <NA>   0     0.0        NA      NA
#> 
#> 
#> carer's gender (c161sex) <numeric>
#> # grouped by: severely dependent
#> # total N=304  valid N=304  mean=1.79  sd=0.41
#> 
#>  val  label frq raw.prc valid.prc cum.prc
#>    1   Male  63    20.7      20.7    20.7
#>    2 Female 241    79.3      79.3   100.0
#>   NA   <NA>   0     0.0        NA      NA
```




```r
flat_table(efc, e42dep, c161sex)
#>                      c161sex Male Female
#> e42dep                                  
#> independent                    18     48
#> slightly dependent             54    170
#> moderately dependent           80    226
#> severely dependent             63    241
```



```r
flat_table(efc, e42dep, c161sex, margin = "col")
#>                      c161sex  Male Female
#> e42dep                                   
#> independent                   8.37   7.01
#> slightly dependent           25.12  24.82
#> moderately dependent         37.21  32.99
#> severely dependent           29.30  35.18
```



```r
library(janitor)
efc %>% tabyl(e42dep, c161sex, show_na = FALSE)
#>  e42dep  1   2
#>       1 18  48
#>       2 54 170
#>       3 80 226
#>       4 63 241
```



## `rec()`: 重新编码

https://strengejacke.github.io/sjmisc/articles/recodingvariables.html


```r
efc$burden <- rec(
  efc$neg_c_7,
  rec = c("min:9=1 [low]; 10:12=2 [moderate]; 13:max=3 [high]; else=NA"),
  var.label = "Subjective burden",
  as.num = FALSE # we want a factor
)
# print frequencies
frq(efc$burden)
#> 
#> Subjective burden (x) <categorical>
#> # total N=908  valid N=892  mean=2.03  sd=0.81
#> 
#>  val    label frq raw.prc valid.prc cum.prc
#>    1      low 280   30.84      31.4    31.4
#>    2 moderate 301   33.15      33.7    65.1
#>    3     high 311   34.25      34.9   100.0
#>   NA     <NA>  16    1.76        NA      NA
```






