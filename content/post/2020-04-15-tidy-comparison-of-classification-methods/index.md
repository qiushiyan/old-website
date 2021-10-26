---
title: Tidy Comparison of Classification Methods
author: Qiushi Yan
date: '2020-04-15'
slug: []
categories:
  - Machine Learning
  - R
summary: 'Evaluate performance of logistic regression, LDA, QDA and KNN in different scenarios using {tidymodels}.'
featured: no
bibliography: ../bib/compare-classification.bib
biblio-style: apalike
link-citations: yes
image:
  caption: 'Screenshot taken from the [ISR](http://faculty.marshall.usc.edu/gareth-james/ISL/) book, page 152, Figure 4.11'
  focal_point: ''
  preview_only: no
draft: yes
---

    ## -- Attaching packages --------------------------------------- tidyverse 1.3.1 --

    ## v ggplot2 3.3.5     v purrr   0.3.4
    ## v tibble  3.1.4     v dplyr   1.0.7
    ## v tidyr   1.1.4     v stringr 1.4.0
    ## v readr   2.0.2     v forcats 0.5.1

    ## Warning: package 'tibble' was built under R version 4.1.1

    ## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

    ## 
    ## FALSE  TRUE 
    ##   132   368
