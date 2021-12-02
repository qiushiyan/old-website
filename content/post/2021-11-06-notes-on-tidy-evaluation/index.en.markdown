---
title: Notes on Tidy Evaluation
author: Qiushi Yan
date: '2021-11-06'
slug: []
categories: []
tags: []
subtitle: ''
summary: ''
authors: []
lastmod: '2021-11-06T21:32:30-05:00'
draft: yes
link-citations: yes
image:
  caption: ''
  focal_point: ''
  preview_only: no
---


```r
library(rlang)
library(magrittr)
```

```
## 
## Attaching package: 'magrittr'
```

```
## The following object is masked from 'package:rlang':
## 
##     set_names
```



```r
expr(plot(mtcars)) %>% 
  str()
```

```
##  language plot(mtcars)
```

```r
string_math <- function(x) {
  enexpr(x)
}
```

