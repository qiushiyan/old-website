---
title: Tidy Data with Python
author: Qiushi Yan
date: '2020-05-12'
slug: python-tidy-data
categories:
  - Python
  - R
  - Data Analysis
summary: "A play with messy data in Hadley Wickham's Tidy Data paper in pandas, finish by exploring a real-world dataset using both R and Python."
subtitle: "A play with messy data in Hadley Wickham's Tidy Data paper in pandas, finish by exploring a real-world dataset using both R and Python."
lastmod: '2020-05-12T22:11:05+08:00'
bibliography: ../bib/python-tidy-data.bib
biblio-style: apalike
link-citations: yes
---

This week I’ve been doing some recap on how to do basic data processing and cleaning in Python with the `pandas` and `NumPy` library. So this post is mostly a self-reminder on how to deal with messy data in Python, by reproducing data cleaning examples presented in Hadley Wickham’s [Tidy Data](https://vita.had.co.nz/papers/tidy-data.pdf) paper, Wickham ([2014](#ref-JSSv059i10)).

The most significant contribution of this well-known work is that it gave clear definition on what “tidy” means for a dataset. There are 3 main requirements, as illustrated on [`tidyr`](https://tidyr.tidyverse.org/)’s website (evolving from what Hadley originally proposed):

1.  Every column is a variable.
2.  Every row is an observation.
3.  Every cell is a single value.

Messy data are, by extension, datasets in volation of these 3 rules. The author then described the five most common problems with messy datasets:

-   Column headers are values, not variable names.
-   Multiple variables are stored in one column.  
-   Variables are stored in both rows and columns.
-   Multiple types of observational units are stored in the same table.  
-   A single observational unit is stored in multiple tables.

In this post I will be focusing on the first 3 symptoms since the other two violations often occur when working with databases. All datasets come from Hadley’s [repo](https://github.com/hadley/tidy-data) containing materials for the paper and [Daniel Chen](https://chendaniely.github.io/)’s 2019 SciPy tutorial on data processing with pandas.

``` python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
```

# Column headers are values, not variable names

``` python
pew = pd.read_csv("https://media.githubusercontent.com/media/qiushiyan/blog-data/master/pew.csv")
pew.head()
#>              religion  <$10k  $10-20k  ...  $100-150k  >150k  Don't know/refused
#> 0            Agnostic     27       34  ...        109     84                  96
#> 1             Atheist     12       27  ...         59     74                  76
#> 2            Buddhist     27       21  ...         39     53                  54
#> 3            Catholic    418      617  ...        792    633                1489
#> 4  Don’t know/refused     15       14  ...         17     18                 116
#> 
#> [5 rows x 11 columns]
```

The `pew` dataset explores the relationship between income and religion in the US, produced by the Pew Research Center. To tidy it, we think of its “right” form if we are to answer data analysis questions. Say, what if we want to a person’s income is influenced by his religion or the other way around. It should be obvious that we need to derive from `pew` a column to indicate the level of a person’s income, and another column being count of any combination of income and religion. `pew` is messy in the sense that all column names besides `religion`, from `<$10k` to `Don't know/refused`, should be different levels (values) of a column storing information about income.

The code to do this is fairly easy in pandas, the `.melt` method is very similar to `tidyr::pivot_longer` and its namesake in the retired `reshape2` package.

``` python
tidy_pew = pew.melt(id_vars = "religion", var_name = "income", value_name = "count")
tidy_pew.head(20)
#>                    religion   income  count
#> 0                  Agnostic    <$10k     27
#> 1                   Atheist    <$10k     12
#> 2                  Buddhist    <$10k     27
#> 3                  Catholic    <$10k    418
#> 4        Don’t know/refused    <$10k     15
#> 5          Evangelical Prot    <$10k    575
#> 6                     Hindu    <$10k      1
#> 7   Historically Black Prot    <$10k    228
#> 8         Jehovah's Witness    <$10k     20
#> 9                    Jewish    <$10k     19
#> 10            Mainline Prot    <$10k    289
#> 11                   Mormon    <$10k     29
#> 12                   Muslim    <$10k      6
#> 13                 Orthodox    <$10k     13
#> 14          Other Christian    <$10k      9
#> 15             Other Faiths    <$10k     20
#> 16    Other World Religions    <$10k      5
#> 17             Unaffiliated    <$10k    217
#> 18                 Agnostic  $10-20k     34
#> 19                  Atheist  $10-20k     27
```

Now let’s calculate the `\(\chi^2\)` statistic in R and the corresponding p value；

``` r
# R 
library(infer)
chisq_stat <- py$tidy_pew %>%
  tidyr::uncount(count) %>% 
  specify(religion ~ income) %>% 
  hypothesize(null = "independence") %>%
  calculate(stat = "Chisq")

py$tidy_pew %>%
  tidyr::uncount(count) %>% 
  specify(religion ~ income) %>% 
  hypothesize(null = "independence") %>%
  visualize(method = "theoretical") +
  shade_p_value(obs_stat = chisq_stat, direction = "right")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-7-1.png" width="768" />

This shows strong relationship between `income` and `religion`.

Another common use of this wide data format is to record regularly spaced observations over time, illustrated by the `billboard` dataset. Ther rank of a specific track in each week after it enters the Billboard top 100 is recorded in 75 columns, `wk1` to `wk75`.

``` python
billboard = pd.read_csv("https://media.githubusercontent.com/media/qiushiyan/blog-data/master/billboard.csv")
billboard
#>      year            artist                    track  ... wk74 wk75  wk76
#> 0    2000             2 Pac  Baby Don't Cry (Keep...  ...  NaN  NaN   NaN
#> 1    2000           2Ge+her  The Hardest Part Of ...  ...  NaN  NaN   NaN
#> 2    2000      3 Doors Down               Kryptonite  ...  NaN  NaN   NaN
#> 3    2000      3 Doors Down                    Loser  ...  NaN  NaN   NaN
#> 4    2000          504 Boyz            Wobble Wobble  ...  NaN  NaN   NaN
#> ..    ...               ...                      ...  ...  ...  ...   ...
#> 312  2000       Yankee Grey     Another Nine Minutes  ...  NaN  NaN   NaN
#> 313  2000  Yearwood, Trisha          Real Live Woman  ...  NaN  NaN   NaN
#> 314  2000   Ying Yang Twins  Whistle While You Tw...  ...  NaN  NaN   NaN
#> 315  2000     Zombie Nation            Kernkraft 400  ...  NaN  NaN   NaN
#> 316  2000   matchbox twenty                     Bent  ...  NaN  NaN   NaN
#> 
#> [317 rows x 81 columns]
```

If we are to answer questions like “what are the average ranking of artisits across all weeks?”, `wk` like columns need to be transformed into values: [^1]

``` python
tidy_billboard = billboard.melt(id_vars = ["year", "artist", "track", "time", "date.entered"],
                                var_name = "week",
                                value_name = "rank")
                                
tidy_billboard
#>        year            artist                    track  ... date.entered  week  rank
#> 0      2000             2 Pac  Baby Don't Cry (Keep...  ...   2000-02-26   wk1  87.0
#> 1      2000           2Ge+her  The Hardest Part Of ...  ...   2000-09-02   wk1  91.0
#> 2      2000      3 Doors Down               Kryptonite  ...   2000-04-08   wk1  81.0
#> 3      2000      3 Doors Down                    Loser  ...   2000-10-21   wk1  76.0
#> 4      2000          504 Boyz            Wobble Wobble  ...   2000-04-15   wk1  57.0
#> ...     ...               ...                      ...  ...          ...   ...   ...
#> 24087  2000       Yankee Grey     Another Nine Minutes  ...   2000-04-29  wk76   NaN
#> 24088  2000  Yearwood, Trisha          Real Live Woman  ...   2000-04-01  wk76   NaN
#> 24089  2000   Ying Yang Twins  Whistle While You Tw...  ...   2000-03-18  wk76   NaN
#> 24090  2000     Zombie Nation            Kernkraft 400  ...   2000-09-02  wk76   NaN
#> 24091  2000   matchbox twenty                     Bent  ...   2000-04-29  wk76   NaN
#> 
#> [24092 rows x 7 columns]
```

Now we can compute the average ranking:

``` python
(tidy_billboard.
  groupby("artist")[["rank"]].
  mean().
  sort_values(by = "rank")
)
#>                                    rank
#> artist                                 
#> Santana                       10.500000
#> Elliott, Missy "Misdemeanor"  14.333333
#> matchbox twenty               18.641026
#> N'Sync                        18.648649
#> Janet                         19.416667
#> ...                                 ...
#> Lil' Mo                       98.142857
#> LL Cool J                     98.500000
#> Zombie Nation                 99.000000
#> Fragma                        99.000000
#> Smith, Will                   99.000000
#> 
#> [228 rows x 1 columns]
```

# Multiple variables stored in one column

> The `tb` daaset comes from the World Health Organisation, and records the counts of confirmed tuberculosis cases by country, year, and demographic group. The demographic groups are broken down by sex (m, f) and age (0–14, 15–25, 25–34, 35–44.

``` python
tb = pd.read_csv("https://media.githubusercontent.com/media/qiushiyan/blog-data/master/tb.csv")
tb
#>     country  year   m014   m1524   m2534  ...   f3544  f4554  f5564   f65  fu
#> 0        AD  2000    0.0     0.0     1.0  ...     NaN    NaN    NaN   NaN NaN
#> 1        AE  2000    2.0     4.0     4.0  ...     3.0    0.0    0.0   4.0 NaN
#> 2        AF  2000   52.0   228.0   183.0  ...   339.0  205.0   99.0  36.0 NaN
#> 3        AG  2000    0.0     0.0     0.0  ...     0.0    0.0    0.0   0.0 NaN
#> 4        AL  2000    2.0    19.0    21.0  ...     8.0    8.0    5.0  11.0 NaN
#> ..      ...   ...    ...     ...     ...  ...     ...    ...    ...   ...  ..
#> 196      YE  2000  110.0   789.0   689.0  ...   517.0  345.0  247.0  92.0 NaN
#> 197      YU  2000    NaN     NaN     NaN  ...     NaN    NaN    NaN   NaN NaN
#> 198      ZA  2000  116.0   723.0  1999.0  ...   933.0  423.0  167.0  80.0 NaN
#> 199      ZM  2000  349.0  2175.0  2610.0  ...  1305.0  186.0  112.0  75.0 NaN
#> 200      ZW  2000    NaN     NaN     NaN  ...     NaN    NaN    NaN   NaN NaN
#> 
#> [201 rows x 18 columns]
```

To clean this data, we first melt all columns except for `country` and `year` in return for a longer version of `tb`, and then seperate the `variable` column into two pieces of information, `sex` and `age`.

``` python
tb_long = tb.melt(id_vars = ["country", "year"])
sex = tb_long["variable"].str.split(pat = "(m|f)(.+)").str.get(1)
age = tb_long["variable"].str.split(pat = "(m|f)(.+)").str.get(2)

print(sex)
#> 0       m
#> 1       m
#> 2       m
#> 3       m
#> 4       m
#>        ..
#> 3211    f
#> 3212    f
#> 3213    f
#> 3214    f
#> 3215    f
#> Name: variable, Length: 3216, dtype: object
print(age)
#> 0       014
#> 1       014
#> 2       014
#> 3       014
#> 4       014
#>        ... 
#> 3211      u
#> 3212      u
#> 3213      u
#> 3214      u
#> 3215      u
#> Name: variable, Length: 3216, dtype: object
```

Add these two columns and drop the redundant `variable` column

``` python
tidy_tb = tb_long.assign(sex = sex, age = age).drop("variable", axis = "columns")
tidy_tb
#>      country  year  value sex  age
#> 0         AD  2000    0.0   m  014
#> 1         AE  2000    2.0   m  014
#> 2         AF  2000   52.0   m  014
#> 3         AG  2000    0.0   m  014
#> 4         AL  2000    2.0   m  014
#> ...      ...   ...    ...  ..  ...
#> 3211      YE  2000    NaN   f    u
#> 3212      YU  2000    NaN   f    u
#> 3213      ZA  2000    NaN   f    u
#> 3214      ZM  2000    NaN   f    u
#> 3215      ZW  2000    NaN   f    u
#> 
#> [3216 rows x 5 columns]
```

# Variables are stored in both rows and columns

> The `weather` data shows daily weather data from the Global Historical Climatology Network for one weather station (MX17004) in Mexico for five months in 2010.

``` python
weather = pd.read_csv("https://media.githubusercontent.com/media/qiushiyan/blog-data/master/weather.csv")
weather
#>          id  year  month element    d1  ...   d27   d28   d29   d30   d31
#> 0   MX17004  2010      1    tmax   NaN  ...   NaN   NaN   NaN  27.8   NaN
#> 1   MX17004  2010      1    tmin   NaN  ...   NaN   NaN   NaN  14.5   NaN
#> 2   MX17004  2010      2    tmax   NaN  ...   NaN   NaN   NaN   NaN   NaN
#> 3   MX17004  2010      2    tmin   NaN  ...   NaN   NaN   NaN   NaN   NaN
#> 4   MX17004  2010      3    tmax   NaN  ...   NaN   NaN   NaN   NaN   NaN
#> 5   MX17004  2010      3    tmin   NaN  ...   NaN   NaN   NaN   NaN   NaN
#> 6   MX17004  2010      4    tmax   NaN  ...  36.3   NaN   NaN   NaN   NaN
#> 7   MX17004  2010      4    tmin   NaN  ...  16.7   NaN   NaN   NaN   NaN
#> 8   MX17004  2010      5    tmax   NaN  ...  33.2   NaN   NaN   NaN   NaN
#> 9   MX17004  2010      5    tmin   NaN  ...  18.2   NaN   NaN   NaN   NaN
#> 10  MX17004  2010      6    tmax   NaN  ...   NaN   NaN  30.1   NaN   NaN
#> 11  MX17004  2010      6    tmin   NaN  ...   NaN   NaN  18.0   NaN   NaN
#> 12  MX17004  2010      7    tmax   NaN  ...   NaN   NaN   NaN   NaN   NaN
#> 13  MX17004  2010      7    tmin   NaN  ...   NaN   NaN   NaN   NaN   NaN
#> 14  MX17004  2010      8    tmax   NaN  ...   NaN   NaN  28.0   NaN  25.4
#> 15  MX17004  2010      8    tmin   NaN  ...   NaN   NaN  15.3   NaN  15.4
#> 16  MX17004  2010     10    tmax   NaN  ...   NaN  31.2   NaN   NaN   NaN
#> 17  MX17004  2010     10    tmin   NaN  ...   NaN  15.0   NaN   NaN   NaN
#> 18  MX17004  2010     11    tmax   NaN  ...  27.7   NaN   NaN   NaN   NaN
#> 19  MX17004  2010     11    tmin   NaN  ...  14.2   NaN   NaN   NaN   NaN
#> 20  MX17004  2010     12    tmax  29.9  ...   NaN   NaN   NaN   NaN   NaN
#> 21  MX17004  2010     12    tmin  13.8  ...   NaN   NaN   NaN   NaN   NaN
#> 
#> [22 rows x 35 columns]
```

There are two major problems with `weather`:

-   `d1`, `d2`, …, `d31` should be values instead of column names (solved by `.melt`)
-   On the other hand, values in the `element` column should be names, it should be spread into two columns named `tmax`, `tmin` (solved by `.pivot_table`)

``` python
(weather.
  melt(id_vars = ["id", "year", "month", "element"], var_name = "day", value_name = "temp").
  pivot_table(index = ["id", "year", "month", "day"],
              columns = "element",
              values = "temp").
  reset_index().
  head()
)
#> element       id  year  month  day  tmax  tmin
#> 0        MX17004  2010      1  d30  27.8  14.5
#> 1        MX17004  2010      2  d11  29.7  13.4
#> 2        MX17004  2010      2   d2  27.3  14.4
#> 3        MX17004  2010      2  d23  29.9  10.7
#> 4        MX17004  2010      2   d3  24.1  14.4
```

# Case study: mortality data from Mexico

After stating these common problems and their remidies, Hadley presented a case study section on how tidy dataset can facilitate data analysis. The case study uses individual-level mortality data from Mexico. The goal is to find causes of death with unusual temporal patterns, at hour level. It’s time to move back from Python to R!

``` r
library(ggplot2)
library(dplyr)
library(tidyr)

deaths <- readr::read_csv("https://media.githubusercontent.com/media/qiushiyan/blog-data/master/mexico-deaths.csv") %>% na.omit()
deaths
#> # A tibble: 513,273 × 5
#>      yod   mod   dod   hod cod  
#>    <dbl> <dbl> <dbl> <dbl> <chr>
#>  1  1920    11    17     3 W78  
#>  2  1923     2     4    16 J44  
#>  3  1923     6    23    19 E12  
#>  4  1926     2     5    16 C67  
#>  5  1926     4     1    16 J44  
#>  6  1928    10    30    19 I27  
#>  7  1929     4    23    15 I25  
#>  8  1930     9    11    19 E14  
#>  9  1930    12    22    19 E11  
#> 10  1931     5    26    11 K65  
#> # … with 513,263 more rows
```

The columns are year, month, day, hour and cause of specific death respectively. Another table `codes` explains what acronyms in `cod` mean.

``` r
codes <- readr::read_csv("https://media.githubusercontent.com/media/qiushiyan/blog-data/master/codes.csv")
codes
#> # A tibble: 1,851 × 2
#>    cod   disease                                                              
#>    <chr> <chr>                                                                
#>  1 A00   "Cholera"                                                            
#>  2 A01   "Typhoid and paratyphoid\nfevers"                                    
#>  3 A02   "Other salmonella infections"                                        
#>  4 A03   "Shigellosis"                                                        
#>  5 A04   "Other bacterial intestinal\ninfections"                             
#>  6 A05   "Other bacterial foodborne\nintoxications, not elsewhere\nclassified"
#>  7 A06   "Amebiasis"                                                          
#>  8 A07   "Other protozoal intestinal\ndiseases"                               
#>  9 A08   "Viral and other specified\nintestinal infections"                   
#> 10 A09   "Diarrhea and gastroenteritis\nof infectious origin"                 
#> # … with 1,841 more rows
```

Thanks to the [`reticulate`](https://rstudio.github.io/reticulate/) package, we can mix R and Python code seamlessly. Here is a line plot made with `seaborn` demonstrating total deaths per hour:

``` python
# Python
deaths = r.deaths
deaths_per_hour = deaths["hod"].value_counts()
deaths_per_hour
#> 18.0    24380
#> 10.0    24321
#> 16.0    23890
#> 11.0    23843
#> 6.0     23787
#> 17.0    23625
#> 12.0    23392
#> 13.0    23284
#> 15.0    23278
#> 14.0    23053
#> 20.0    22926
#> 19.0    22919
#> 9.0     22401
#> 5.0     22126
#> 8.0     21915
#> 7.0     21822
#> 23.0    21446
#> 21.0    20995
#> 22.0    20510
#> 1.0     20430
#> 4.0     20239
#> 3.0     19729
#> 2.0     18962
#> Name: hod, dtype: int64
sns.lineplot(x = deaths_per_hour.index, y = deaths_per_hour.values)
plt.title("Temporal pattern of all causes of death")
plt.xlabel("Hour of the day")
plt.ylabel("Number of deaths")
plt.show()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-18-1.png" width="768" />

To provide informative labels for causes, we next join the dataset to the `codes` dataset, on the `cod` variable.

``` r
deaths <- left_join(deaths, codes) %>%
  rename(cause = disease)
head(deaths)
#> # A tibble: 6 × 6
#>     yod   mod   dod   hod cod   cause                                         
#>   <dbl> <dbl> <dbl> <dbl> <chr> <chr>                                         
#> 1  1920    11    17     3 W78   "Inhalation of gastric\ncontents"             
#> 2  1923     2     4    16 J44   "Other chronic obstructive\npulmonary disease"
#> 3  1923     6    23    19 E12   "Malnutrition-related diabetes\nmellitus"     
#> 4  1926     2     5    16 C67   "Malignant neoplasm of bladder"               
#> 5  1926     4     1    16 J44   "Other chronic obstructive\npulmonary disease"
#> 6  1928    10    30    19 I27   "Other pulmonary heart\ndiseases"
```

The total deaths for each cause varies over several orders of magnitude: there are 46,794 deaths from heart attack but only 1 from Tularemia.

``` python
# Python
(deaths.groupby(["cod"]).
  size().
  reset_index(name = "per_cause").
  sort_values(by = "per_cause", ascending = False)
)
#>       cod  per_cause
#> 417   I21      46794
#> 260   E11      42421
#> 262   E14      27330
#> 495   J44      16043
#> 566   K70      12860
#> ...   ...        ...
#> 1079  X24          1
#> 521   K02          1
#> 939   V30          1
#> 940   V33          1
#> 182   D04          1
#> 
#> [1194 rows x 2 columns]
```

This means that rather than the total number, it makes more sense to think in proportions. If a cause of death departs from the overall temporal pattern, then its proportion of deaths in a given hour compared to the total deaths of that cause should differ significantly from that of the hourly deaths at the same time compared to total deaths. I denote these two proportions as `prop1` and `prop2` respectively. To ensure that the causes we consider are sufficiently representative we’ll only work with causes with more than 50 total deaths.

``` r
prop1 <- deaths %>% 
  count(hod, cause, name = "per_hour_per_cause") %>% 
  add_count(cause, wt = per_hour_per_cause, name = "per_cause") %>% 
  mutate(prop1 = per_hour_per_cause / per_cause)

prop2 <- deaths %>% 
  count(hod, name = "per_hour") %>% 
  add_count(wt = per_hour, name = "total") %>% 
  mutate(prop2 = per_hour / total)
```

Hadley used mean square error between the two proportions as a kind of distance, to indicate the average degree of anomaly of a cause, and I follow:

``` r
dist <- prop1 %>% 
  filter(per_cause > 50) %>% 
  left_join(prop2, on = "hod") %>% 
  select(hour = hod,
         cause,
         n = per_cause,
         prop1,
         prop2) %>% 
  group_by(cause, n) %>% 
  summarize(dist = mean((prop1 - prop2) ^ 2)) %>% 
  ungroup()

dist %>% 
  arrange(desc(dist))
#> # A tibble: 447 × 3
#>    cause                                                               n    dist
#>    <chr>                                                           <int>   <dbl>
#>  1 "Accident to powered aircraft\ncausing injury to occupant"         57 0.00573
#>  2 "Victim of lightning"                                              97 0.00513
#>  3 "Bus occupant injured in other\nand unspecified transport\nacc…    52 0.00419
#>  4 "Assault (homicide) by smoke,\nfire, and flames"                   51 0.00229
#>  5 "Exposure to electric\ntransmission lines"                         77 0.00161
#>  6 "Sudden infant death syndrome"                                    323 0.00156
#>  7 "Drowning and submersion while\nin natural water"                 469 0.00133
#>  8 "Motorcycle rider injured in\ncollision with car, pickup\ntruc…    66 0.00126
#>  9 "Contact with hornets, wasps,\nand bees"                           86 0.00118
#> 10 "Exposure to smoke, fire, and\nflames, undetermined intent"        51 0.00110
#> # … with 437 more rows
```

Here we see causes of death with highest `dist` are mainly accidents and rare diseases. However, there is a negative correlation between the frequency of a cause and its deviation, as shown in the following plot, so that the result based solely on the `dist` column would be biased in favour of rare causes.

``` r
dist %>% 
  ggplot(aes(n, dist)) + 
  geom_jitter() + 
  ggrepel::geom_text_repel(aes(label = cause),
                           top_n(dist, 10)) + 
  scale_x_log10() + 
  scale_y_log10() + 
  geom_smooth(method = "lm") + 
  labs(title = "Temporal deviation of causes of deaths in Mexico",
       y = NULL,
       x = "total death")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-23-1.png" width="960" />

Thus, our final solution is to build a model with `n` as predictor, and `dist` as response. The cause with highest residual are assumed to have the most deviation. Since the linear trend fits the data quite well, I opt for linear regression (Hadley used robust linear model in the paper).

``` r
library(broom)
lm_fit <- lm(log(dist) ~ log(n), data = dist)
tidy(lm_fit)
#> # A tibble: 2 × 5
#>   term        estimate std.error statistic   p.value
#>   <chr>          <dbl>     <dbl>     <dbl>     <dbl>
#> 1 (Intercept)   -3.74     0.110      -34.0 8.34e-126
#> 2 log(n)        -0.869    0.0186     -46.8 7.55e-174
```

Let’s plot these residuals against the predictor `log(n)`:

``` r
augment(lm_fit) %>% 
  ggplot(aes(`log(n)`, .std.resid)) + 
  geom_hline(yintercept = 0, color = "red") + 
  geom_point()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-25-1.png" width="768" />

> The plot shows an empty region around a standardized residual of 1.5. So somewhat arbitrarily, we’ll select those diseases with a residual greater than 1.5

``` r
rows <- augment(lm_fit) %>% 
  mutate(row = row_number()) %>% 
  filter(.std.resid> 1.5) %>% 
  select(row) %>% 
  pull(row)


unusual <- dist %>%
  mutate(row = row_number()) %>% 
  filter(row %in% rows) %>% 
  select(cause, n)

unusual
#> # A tibble: 26 × 2
#>    cause                                                                     n
#>    <chr>                                                                 <int>
#>  1 "Accident to powered aircraft\ncausing injury to occupant"               57
#>  2 "Acute bronchitis"                                                      684
#>  3 "Acute myocardial infarction"                                         46794
#>  4 "Assault (homicide) by other\nand unspecified firearm\ndischarge"      7228
#>  5 "Assault (homicide) by sharp\nobject"                                  1575
#>  6 "Assault (homicide) by smoke,\nfire, and flames"                         51
#>  7 "Bus occupant injured in other\nand unspecified transport\naccidents"    52
#>  8 "Car occupant injured in\nnoncollision transport\naccident"             616
#>  9 "Car occupant injured in other\nand unspecified transport\naccidents"  1938
#> 10 "Contact with hornets, wasps,\nand bees"                                 86
#> # … with 16 more rows
```

Finally, we plot the temporal course for each unusual cause of death.

``` r
prop1 %>% 
  filter(cause %in% unusual$cause) %>% 
  left_join(prop2, on = "hod") %>% 
  pivot_longer(c(prop1, prop2)) %>% 
  ggplot(aes(hod, value, color = name)) + 
  geom_line() + 
  scale_color_manual(name = NULL,
                     labels = c("cause-specific", "overall"), 
                     values = c("#FFBF0F", "#0382E5")) + 
  facet_wrap(~ cause, scales = "free_y") + 
  labs(x = "hour", y = NULL, title = "Most deviated causes of death", 
       subtitle = "comparing cause-specific temporal pattern to overall trend") + 
  theme_minimal(base_size = 22) +
  theme(legend.position = "top") 
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-27-1.png" width="1536" />

# References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-JSSv059i10" class="csl-entry">

Wickham, Hadley. 2014. “Tidy Data.” *Journal of Statistical Software, Articles* 59 (10): 1–23. <https://doi.org/10.18637/jss.v059.i10>.

</div>

</div>

[^1]: Although pandas and dplyr 1.0 can perform rowwise operatios in a breeze, it’s not considered best practice in such cases.
