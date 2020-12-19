---
title: Modeling Titanic survival 
summary: Predicting Titaic surviavl patterns with logistic regression
abstract: ""
date: "2020-11-23"
image:
  caption: '[Photo by Anders Jildén on Unsplash](https://unsplash.com/photos/PXdBkNF8rlk)'
  focal_point: Smart
links:
- icon: file-pdf
  icon_pack: fas
  name: paper
  url: /files/titanic-survival.pdf
- icon: github
  icon_pack: fab
  name: code
  url: https://github.com/enixam/titanic-survival


tags:
- R
- Case Study
---

This case study showcases the development of a binary logistic model to predict the probability of survival in the loss of Titanic. I demonstrate the overall modeling process, including preprocessing, exploratory analysis,  model fitting, adjustment, bootstrap internal validation and interpretation as well as other relevant techniques such as redundancy analysis and multiple imputation for missing data. The motivation and justification behind critical statistical decisions are explained, touching on key issues such as the choice of a statistical model or a machine learning model, using bootstrap to alleviate selection bias, disadvantages of the holdout sample approach in validation, and more. This analysis is fully reproducible with all source R code and text. 

In addition to modeling, we answer the following practical questions 

- To what degree is the *women and children policy* put into effect, and how it was interwoven with socio-economic status and self interest. 

- What's the crewmembers's surviving situation, and did they fulfill their responsibilities to rescue passengers first. 

- Does having companions (e.g., parents, children, siblings and spouse) on the vessel increase or decrease survival probability. 

- The impact of nationality. For example, did English subjects gained an advantage in a British-managed ship. 