---
title: Bag of Tricks in data.table
author: Qiushi Yan
date: '2021-09-02'
slug: []
categories: []
tags: []
summary: "Tricks in R's data.table package"
lastmod: '2021-09-02T15:39:33-05:00'
draft: yes
---





```r
library(data.table)
```

[friends](https://github.com/EmilHvitfeldt/friends) package


```r
dt <- as.data.table(friends::friends_info)
dt
#>      season episode                                          title
#>   1:      1       1                                      The Pilot
#>   2:      1       2           The One with the Sonogram at the End
#>   3:      1       3                         The One with the Thumb
#>   4:      1       4             The One with George Stephanopoulos
#>   5:      1       5 The One with the East German Laundry Detergent
#>  ---                                                              
#> 232:     10      14                 The One with Princess Consuela
#> 233:     10      15                     The One Where Estelle Dies
#> 234:     10      16         The One with Rachel's Going Away Party
#> 235:     10      17                                   The Last One
#> 236:     10      18                                   The Last One
#>          directed_by
#>   1:   James Burrows
#>   2:   James Burrows
#>   3:   James Burrows
#>   4:   James Burrows
#>   5:   Pamela Fryman
#>  ---                
#> 232:  Gary Halvorson
#> 233:  Gary Halvorson
#> 234:  Gary Halvorson
#> 235: Kevin S. Bright
#> 236: Kevin S. Bright
#>                                                                           written_by
#>   1:                                                    David Crane & Marta Kauffman
#>   2:                                                    David Crane & Marta Kauffman
#>   3:                                                  Jeffrey Astrof & Mike Sikowitz
#>   4:                                                                     Alexa Junge
#>   5:                                                  Jeff Greenstein & Jeff Strauss
#>  ---                                                                                
#> 232:               Story by<U+200A>: Robert CarlockTeleplay by<U+200A>: Tracy Reilly
#> 233: Story by<U+200A>: Mark KunerthTeleplay by<U+200A>: David Crane & Marta Kauffman
#> 234:                                                        Andrew Reich & Ted Cohen
#> 235:                                                    Marta Kauffman & David Crane
#> 236:                                                    Marta Kauffman & David Crane
#>        air_date us_views_millions imdb_rating
#>   1: 1994-09-22             21.50         8.3
#>   2: 1994-09-29             20.20         8.1
#>   3: 1994-10-06             19.50         8.2
#>   4: 1994-10-13             19.70         8.1
#>   5: 1994-10-20             18.60         8.5
#>  ---                                         
#> 232: 2004-02-26             22.83         8.6
#> 233: 2004-04-22             22.64         8.5
#> 234: 2004-04-29             24.51         8.9
#> 235: 2004-05-06             52.46         9.7
#> 236: 2004-05-06             52.46         9.7
```


# Change in Place: the reference semantics 

# Special Symbols

## .N 

## .SD and .SDcols 


```r
dt[, lapply(.SD, mean), season, .SDcols = c("imdb_rating", "us_views_millions")]
#>     season imdb_rating us_views_millions
#>  1:      1    8.316667          24.79167
#>  2:      2    8.458333          31.72083
#>  3:      3    8.408000          26.30800
#>  4:      4    8.475000          24.95000
#>  5:      5    8.637500          24.74583
#>  6:      6    8.496000          22.61600
#>  7:      7    8.437500          22.05125
#>  8:      8    8.450000          26.72042
#>  9:      9    8.304167          23.93042
#> 10:     10    8.688889          26.12944
```


# Using keys and index 





# Tidy Data

- `melt(data, id.vars, measure.vars, variable.name = "variable", value.name = "value")`: wide to long

- `dcast(data, formula, value.var)`: long to wide 


```r
bil <- as.data.table(tidyr::billboard)
bil
#>                artist                   track date.entered wk1 wk2 wk3 wk4 wk5
#>   1:            2 Pac Baby Don't Cry (Keep...   2000-02-26  87  82  72  77  87
#>   2:          2Ge+her The Hardest Part Of ...   2000-09-02  91  87  92  NA  NA
#>   3:     3 Doors Down              Kryptonite   2000-04-08  81  70  68  67  66
#>   4:     3 Doors Down                   Loser   2000-10-21  76  76  72  69  67
#>   5:         504 Boyz           Wobble Wobble   2000-04-15  57  34  25  17  17
#>  ---                                                                          
#> 313:      Yankee Grey    Another Nine Minutes   2000-04-29  86  83  77  74  83
#> 314: Yearwood, Trisha         Real Live Woman   2000-04-01  85  83  83  82  81
#> 315:  Ying Yang Twins Whistle While You Tw...   2000-03-18  95  94  91  85  84
#> 316:    Zombie Nation           Kernkraft 400   2000-09-02  99  99  NA  NA  NA
#> 317:  matchbox twenty                    Bent   2000-04-29  60  37  29  24  22
#>      wk6 wk7 wk8 wk9 wk10 wk11 wk12 wk13 wk14 wk15 wk16 wk17 wk18 wk19 wk20
#>   1:  94  99  NA  NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   2:  NA  NA  NA  NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   3:  57  54  53  51   51   51   51   47   44   38   28   22   18   18   14
#>   4:  65  55  59  62   61   61   59   61   66   72   76   75   67   73   70
#>   5:  31  36  49  53   57   64   70   75   76   78   85   92   96   NA   NA
#>  ---                                                                       
#> 313:  79  88  95  NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 314:  91  NA  NA  NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 315:  78  74  78  85   89   97   96   99   99   NA   NA   NA   NA   NA   NA
#> 316:  NA  NA  NA  NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 317:  21  18  16  13   12    8    6    1    2    3    2    2    3    4    5
#>      wk21 wk22 wk23 wk24 wk25 wk26 wk27 wk28 wk29 wk30 wk31 wk32 wk33 wk34 wk35
#>   1:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   2:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   3:   12    7    6    6    6    5    5    4    4    4    4    3    3    3    4
#>   4:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   5:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>  ---                                                                           
#> 313:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 314:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 315:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 316:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 317:    4    4    6    9   12   13   19   20   20   24   29   28   27   30   33
#>      wk36 wk37 wk38 wk39 wk40 wk41 wk42 wk43 wk44 wk45 wk46 wk47 wk48 wk49 wk50
#>   1:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   2:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   3:    5    5    9    9   15   14   13   14   16   17   21   22   24   28   33
#>   4:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   5:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>  ---                                                                           
#> 313:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 314:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 315:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 316:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 317:   37   38   38   48   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>      wk51 wk52 wk53 wk54 wk55 wk56 wk57 wk58 wk59 wk60 wk61 wk62 wk63 wk64 wk65
#>   1:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   2:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   3:   42   42   49   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   4:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   5:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>  ---                                                                           
#> 313:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 314:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 315:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 316:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 317:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>      wk66 wk67 wk68 wk69 wk70 wk71 wk72 wk73 wk74 wk75 wk76
#>   1:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   2:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   3:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   4:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   5:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>  ---                                                       
#> 313:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 314:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 315:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 316:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 317:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
```



```r
bil_long <- melt(bil, measure.vars = patterns("^wk"), 
                 variable.name = "week", value.name = "ranking")
bil_long
#>                  artist                   track date.entered week ranking
#>     1:            2 Pac Baby Don't Cry (Keep...   2000-02-26  wk1      87
#>     2:          2Ge+her The Hardest Part Of ...   2000-09-02  wk1      91
#>     3:     3 Doors Down              Kryptonite   2000-04-08  wk1      81
#>     4:     3 Doors Down                   Loser   2000-10-21  wk1      76
#>     5:         504 Boyz           Wobble Wobble   2000-04-15  wk1      57
#>    ---                                                                   
#> 24088:      Yankee Grey    Another Nine Minutes   2000-04-29 wk76      NA
#> 24089: Yearwood, Trisha         Real Live Woman   2000-04-01 wk76      NA
#> 24090:  Ying Yang Twins Whistle While You Tw...   2000-03-18 wk76      NA
#> 24091:    Zombie Nation           Kernkraft 400   2000-09-02 wk76      NA
#> 24092:  matchbox twenty                    Bent   2000-04-29 wk76      NA
```



```r
dcast(bil_long, ... ~ week, value.var = "ranking")
#>                artist                   track date.entered wk1 wk2 wk3 wk4 wk5
#>   1:            2 Pac Baby Don't Cry (Keep...   2000-02-26  87  82  72  77  87
#>   2:          2Ge+her The Hardest Part Of ...   2000-09-02  91  87  92  NA  NA
#>   3:     3 Doors Down              Kryptonite   2000-04-08  81  70  68  67  66
#>   4:     3 Doors Down                   Loser   2000-10-21  76  76  72  69  67
#>   5:         504 Boyz           Wobble Wobble   2000-04-15  57  34  25  17  17
#>  ---                                                                          
#> 313:      Yankee Grey    Another Nine Minutes   2000-04-29  86  83  77  74  83
#> 314: Yearwood, Trisha         Real Live Woman   2000-04-01  85  83  83  82  81
#> 315:  Ying Yang Twins Whistle While You Tw...   2000-03-18  95  94  91  85  84
#> 316:    Zombie Nation           Kernkraft 400   2000-09-02  99  99  NA  NA  NA
#> 317:  matchbox twenty                    Bent   2000-04-29  60  37  29  24  22
#>      wk6 wk7 wk8 wk9 wk10 wk11 wk12 wk13 wk14 wk15 wk16 wk17 wk18 wk19 wk20
#>   1:  94  99  NA  NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   2:  NA  NA  NA  NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   3:  57  54  53  51   51   51   51   47   44   38   28   22   18   18   14
#>   4:  65  55  59  62   61   61   59   61   66   72   76   75   67   73   70
#>   5:  31  36  49  53   57   64   70   75   76   78   85   92   96   NA   NA
#>  ---                                                                       
#> 313:  79  88  95  NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 314:  91  NA  NA  NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 315:  78  74  78  85   89   97   96   99   99   NA   NA   NA   NA   NA   NA
#> 316:  NA  NA  NA  NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 317:  21  18  16  13   12    8    6    1    2    3    2    2    3    4    5
#>      wk21 wk22 wk23 wk24 wk25 wk26 wk27 wk28 wk29 wk30 wk31 wk32 wk33 wk34 wk35
#>   1:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   2:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   3:   12    7    6    6    6    5    5    4    4    4    4    3    3    3    4
#>   4:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   5:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>  ---                                                                           
#> 313:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 314:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 315:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 316:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 317:    4    4    6    9   12   13   19   20   20   24   29   28   27   30   33
#>      wk36 wk37 wk38 wk39 wk40 wk41 wk42 wk43 wk44 wk45 wk46 wk47 wk48 wk49 wk50
#>   1:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   2:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   3:    5    5    9    9   15   14   13   14   16   17   21   22   24   28   33
#>   4:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   5:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>  ---                                                                           
#> 313:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 314:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 315:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 316:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 317:   37   38   38   48   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>      wk51 wk52 wk53 wk54 wk55 wk56 wk57 wk58 wk59 wk60 wk61 wk62 wk63 wk64 wk65
#>   1:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   2:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   3:   42   42   49   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   4:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   5:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>  ---                                                                           
#> 313:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 314:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 315:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 316:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 317:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>      wk66 wk67 wk68 wk69 wk70 wk71 wk72 wk73 wk74 wk75 wk76
#>   1:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   2:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   3:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   4:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>   5:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#>  ---                                                       
#> 313:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 314:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 315:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 316:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
#> 317:   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA   NA
```



# data.table's Miscellaneous Functions 

`copy`

`patterns`