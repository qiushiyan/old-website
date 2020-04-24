library(tidyverse)
library(broom)

x <- rnorm(500)

df <- tibble(x = x, 
             noise = rnorm(500, sd = 0.001),
             probability = 1 / (1 + exp(1 - x)) + noise,
             y = factor(rbinom(n = 500, size = 1, prob = probability)))

mod <- glm(y ~ x, family = "binomial", data = df) 


pre <- if_else(predict(mod, type = "response") > 0.5,
          "1", "0")

table(pre == df$y)
