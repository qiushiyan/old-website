---
title: 'ggplot2 Lessons from "The Fundamentals of Data Visualization"' 
author: Qiushi Yan
date: '2021-10-13'
slug: []
categories: []
tags: []
subtitle: ''
summary: ''
authors: []
lastmod: '2021-10-13T22:01:32-05:00'
draft: yes
image:
  caption: ''
  focal_point: ''
  preview_only: no
---


```r
library(dviz.supp)
```

```
## Loading required package: cowplot
```

```
## Loading required package: colorspace
```

```
## Loading required package: colorblindr
```

```
## Loading required package: ggplot2
```

```
## Loading required package: dplyr
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```
## 
## Attaching package: 'dviz.supp'
```

```
## The following objects are masked from 'package:cowplot':
## 
##     plot_grid, stamp, stamp_bad, stamp_good, stamp_ugly, stamp_wrong
```

```
## The following object is masked from 'package:datasets':
## 
##     CO2
```

```r
library(ggridges)
```

```
## 
## Attaching package: 'ggridges'
```

```
## The following object is masked from 'package:dviz.supp':
## 
##     Aus_athletes
```

```r
theme_set(theme_minimal())

titanic2 <- titanic
titanic2$sex <- factor(titanic2$sex, levels = c("male", "female"))
```




```r
ggplot(titanic2, aes(age, y = ..count..)) + 
  geom_density(data = . %>% select(-sex), 
               aes(fill = "all passengers"), color = "transparent") + 
  geom_density(aes(fill = sex), bw = 2, color = "transparent") + 
  facet_wrap(~ sex) + 
  scale_fill_manual(
    values = c("#b3b3b3a0", "#D55E00", "#0072B2"), 
    breaks = c("all passengers", "male", "female"),
    labels = c("all passengers  ", "males  ", "females"),
    name = NULL,
    guide = guide_legend(direction = "horizontal")
  ) + 
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = "top")
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-2-1.png" width="768" />




```r
titanic2 %>% 
  mutate(age_level = cut(age, breaks = 8)) %>% 
  count(sex, age_level) %>%
  ggplot(aes(x = age_level, y = ifelse(sex == "male",-1, 1)*n, fill = sex)) + 
  geom_col() +  
  scale_x_discrete(name = "age (years)") +
  scale_y_continuous(name = "count", breaks = 20*(-2:1), labels = c("40", "20", "0", "20")) +
  scale_fill_manual(values = c("#D55E00", "#0072B2"), guide = "none") + 
  coord_flip()
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-3-1.png" width="768" />

