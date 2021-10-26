---
title: Who is Carrying There Team in OWL?
author: Qiushi Yan
date: '2020-04-25'
categories: ["Data Analysis", "Overwatch", "R"]
summary: "Fleta deadlifts in all 3 positions"
lastmod: '2020-04-25T00:09:45+08:00'
featured: no
bibliography: ../bib/fleta-deadlift.bib
biblio-style: apalike
link-citations: yes
image:
  focal_point: ''
  preview_only: yes
draft: yes
---

# The Fleta deadlift

The [Overwatch Stats Lab](https://overwatchleague.com/en-us/statslab) is a treasure trove holding vast digital riches for people who want to observe the Overwatch League in a more detailed manner. One of my favourite statistic is the **Fleta deadlift**, calculated as

$$
\text{Fleta deadlifts} = \frac{\text{final blows of a player}}{\text{final blows of the whole team}}
$$
It comes as no surprise that the index was named after Fleta, the current Shanghai dragons DPS player, who is known for his former amazing performance in a less talented team before he joined Seoul Dyanasty and entered OWL. If you are not familiar with esports or overwatch, I have some equivelent “Fleta deadlifted his team” examples in the NBA context:

-   Michael Jordan in the 1998 final  
-   Kobe Bryant (I miss him) in season 2006-2007, or perhaps half time in his career  
-   Lebron Jmaes in the 2015 final

The player section on Overwatch Stats Lab even established a special tab for this stat, showing records with Fleta deadlift &gt; 50% (see the last tab below):  
<iframe src="https://overwatchleague.com/en-us/statslab-players" width="768" height="400px" data-external="1"></iframe>

It should be obvious though, that Fleta deadlifts are more suitable for describe performaces of DPS players, and less applicable to the other two positions, tanks and supports. Since final blows may not be a good measure for a player’s performance if his main responsibility indicates otherwise.

I used `load_data.R` to laod in data and do soem preprocessing. You can browse it at.

``` r
library(tidyverse)
library(vroom)

df <- vroom("D:/RProjects/data/overwatch/fleta_deadlifts.csv")
```

## Extend the stat to tanks and supports

However, since OWL mandates the 2-2-2 composition only after the third stage in season 2019. A player can belong to different positions even in the same map or match.

``` r
dpss <- c("Hanzo", "Junkrat", "Tracer", "Soldier: 76", "Widowmaker", "McCree", "Pharah", "Genji", "Sombra", "Reaper", "Doomfist", "Bastion", "Mei", "Torbjörn", "Symmetra", "Ashe")
tanks <- c("Orisa", "Winston", "Roadhog", "D.Va", "Zarya", "Reinhardt", "Wrecking Ball")
supports <- c("Lúcio", "Mercy", "Zenyatta", "Brigitte", "Moira", "Ana", "Sigma", "Baptiste")

dps_records <- df %>% filter(hero %in% dpss)
tank_records <- df %>% filter(hero %in% tanks)
support_records <- df %>% filter(hero %in% supports)
```

For dps players, I will stick to the official measure of a Fleta deadlift: involved in more than 50% percent of team total final blows in a match.

``` r
dps_deadlifts <- dps_records %>% 
  filter(stat_name == "Final Blows") %>% 
  mutate(final_blows = stat_amount) %>% 
  select(-stat_name, -stat_amount) %>%
  add_count(date, team, wt = final_blows, name = "team_final_blows") %>%
  filter(team_final_blows > 10) %>% 
  group_by(date, player, team_final_blows) %>%
  summarize(player_final_blows = sum(final_blows)) %>%
  ungroup() %>%
  mutate(rate = player_final_blows / team_final_blows) %>%
  filter(rate > 0.5) 

dps_deadlifts
#> # A tibble: 827 x 5
#>    date       player   team_final_blows player_final_blows  rate
#>    <date>     <chr>               <dbl>              <dbl> <dbl>
#>  1 2018-01-11 babybay                95                 48 0.505
#>  2 2018-01-11 carpe                  44                 25 0.568
#>  3 2018-01-11 EFFECT                139                 70 0.504
#>  4 2018-01-11 Fleta                 131                 68 0.519
#>  5 2018-01-11 Jake                   35                 20 0.571
#>  6 2018-01-11 Profit                 90                 58 0.644
#>  7 2018-01-11 TviQ                   80                 42 0.525
#>  8 2018-01-11 Undead                 35                 18 0.514
#>  9 2018-01-12 Jake                   95                 49 0.516
#> 10 2018-01-13 Birdring              100                 52 0.52 
#> # ... with 817 more rows
```
