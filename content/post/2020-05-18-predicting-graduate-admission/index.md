---
title: Predicting Graduate Admission for Internaitonal student
author: Qiushi Yan
date: '2020-05-18'
slug: []
categories:
  - R
  - Data Analysis
  - Machine Learning
tags: []
subtitle: ''
summary: ''
authors: []
lastmod: '2020-05-18T18:29:49+08:00'
draft: yes
bibliography: ../bib/graduate-admission.bib
biblio-style: apalike
link-citations: yes
image:
  caption: ''
  focal_point: ''
  preview_only: no
---

https://www.kaggle.com/eswarchandt/admission?

``` r
library(tidyverse)


admission <- readxl::read_excel("D:/RProjects/data/blog/admission.xlsx") %>% 
  janitor::clean_names() %>% 
  mutate(admit = factor(admit))
```

``` r
library(tidymodels)

admission_split <- initial_split(admission)
admission_test <- testing(admission_split)
admission_train <- training(admission_split)
```

``` r
rec <- recipe(admit ~ ., data = admission_train) %>% 
  step_mutate_at(all_predictors(), -gre, -gpa, fn = factor) %>%
  step_dummy(all_nominal(), -all_outcomes()) %>% 
  step_normalize(gre, gpa)
```
