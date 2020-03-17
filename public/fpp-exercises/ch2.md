






# Time series graphics  


```r
library(lubridate)
library(tsibble)
library(tsibbledata)
library(fable)
library(feasts)
```


\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:unnamed-chunk-3"><strong>(\#exr:unnamed-chunk-3) </strong></span>Use the `help()` function to explore what the series `gafa_stock`, `PBS`, `vic_elec` and `pelt` represent. 

* Use `autoplot()` to plot some of the series in these data sets.  

* What is the time interval of each series?  
  
* Use `filter()` to find what days corresponded to the peak closing price for each of the four stocks in gafa_stock.  </div>\EndKnitrBlock{exercise}



`gafa_stock`: Historical stock prices from 2014-2018 for Google, Amazon, Facebook and Apple.  
`PBS`: Monthly Medicare Australia prescription data  
`vic_elec`: Half-hourly electricity demand for Victoria, Australia  
`pelt`: Hudson Bay Company trading records for Snowshoe Hare and Canadian Lynx furs from 1845 to 1935.  

Use `autoplot()` on `pelt`, both `Hare` and `Lynx` are showing some sort of cyclic patterns:  


```r
pelt %>% autoplot(Hare)
```

<img src="ch2_files/figure-html/unnamed-chunk-4-1.png" width="80%" style="display: block; margin: auto;" />

```r
pelt %>% autoplot(Lynx)
```

<img src="ch2_files/figure-html/unnamed-chunk-4-2.png" width="80%" style="display: block; margin: auto;" />

The four respective time interval are day (irregular but collected on a daily basis for the most part), month, 30 minutes and year.  


```r
gafa_stock %>% 
  group_by(Symbol) %>% 
  filter(min_rank(desc(Close)) == 1)
#> # A tsibble: 4 x 8 [!]
#> # Key:       Symbol [4]
#> # Groups:    Symbol [4]
#>   Symbol Date        Open  High   Low Close Adj_Close   Volume
#>   <chr>  <date>     <dbl> <dbl> <dbl> <dbl>     <dbl>    <dbl>
#> 1 AAPL   2018-10-03  230.  233.  230.  232.      230. 28654800
#> 2 AMZN   2018-09-04 2026. 2050. 2013  2040.     2040.  5721100
#> 3 FB     2018-07-25  216.  219.  214.  218.      218. 58954200
#> 4 GOOG   2018-07-26 1251  1270. 1249. 1268.     1268.  2405600
```




\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:unnamed-chunk-6"><strong>(\#exr:unnamed-chunk-6) </strong></span>The `aus_livestock` data contains the monthly total number of pigs slaughtered in Victoria, Australia, from Jul 1972 to Dec 2018. Use `filter()` to extract pig slaughters in Victoria between 1990 and 1995. Use `autoplot()` and ACF for this data and compare these to white noise plots.</div>\EndKnitrBlock{exercise}




```r
aus_livestock <- aus_livestock %>%
  mutate(year = year(Month)) %>% 
  filter(year >= 1990, year <= 1995, 
         Animal == "Pigs",
         State == "Victoria")

aus_livestock
#> # A tsibble: 72 x 5 [1M]
#> # Key:       Animal, State [1]
#>      Month Animal State    Count  year
#>      <mth> <fct>  <fct>    <dbl> <dbl>
#> 1 1990 Jan Pigs   Victoria 76000  1990
#> 2 1990 Feb Pigs   Victoria 78100  1990
#> 3 1990 Mar Pigs   Victoria 77600  1990
#> 4 1990 Apr Pigs   Victoria 84100  1990
#> 5 1990 May Pigs   Victoria 98000  1990
#> 6 1990 Jun Pigs   Victoria 89100  1990
#> # ... with 66 more rows
```



```r
aus_livestock %>% autoplot(Count)
aus_livestock %>% gg_season(Count)
```

<img src="ch2_files/figure-html/unnamed-chunk-8-1.png" width="50%" /><img src="ch2_files/figure-html/unnamed-chunk-8-2.png" width="50%" />


```r
aus_livestock %>% 
  ACF(Count) %>%
  autoplot()
```

<img src="ch2_files/figure-html/unnamed-chunk-9-1.png" width="80%" style="display: block; margin: auto;" />

Based on current plots, it seems that pig slaughters in Victoria between 1990 and 1995 expericenced a general increase despite fluctuations. Lag plots have shown some sort of seasonality on a yearly basis. Pig slaughters tend to peak in one of the summer months, while remaining at a faily low level at both ends of a year.    



\BeginKnitrBlock{exercise}<div class="exercise"><span class="exercise" id="exr:unnamed-chunk-10"><strong>(\#exr:unnamed-chunk-10) </strong></span>The following time plots and ACF plots correspond to four different time series. Your task is to match each time plot in the first row with one of the ACF plots in the second row.</div>\EndKnitrBlock{exercise}


<img src="images/match_acf.png" width="80%" style="display: block; margin: auto;" />


**3 -> D**, **1 -> B**, both time series have a long-term trend (increasing and decreasing respectively), and the ACF plots should generally turn to be positive. And there is a clear seasonal effect in monthly air passengers so that its corresponding ACF plots should not be within the zero interval.  

**2 -> A, 4 -> C**, time plot 2 has demonstrated seasonality within a year, while plot 4 seems to have some white noise.




