library(tidyverse)
library(lubridate)
library(vroom)


season_2020 <- vroom("D:/RProjects/data/overwatch/phs_2020/phs_2020_1.csv") %>% 
  mutate(stage = "2020_regular_season") %>%
  transmute(date = as_date(mdy_hm(start_time)),
            player = player_name,
            team = team_name,
            map = map_name,
            hero = hero_name,
            stat_name,
            stat_amount,
            stage)

season_2019 <- fs::dir_ls("D:/RProjects/data/overwatch/phs_2019/") %>% 
  set_names("2019_playoffs", 
            "2019_stage_1", 
            "2019_stage_2", 
            "2019_stage_3", 
            "2019_stage_4") %>% 
  imap_dfr(~ vroom(.x) %>% mutate(stage = .y)) %>% 
  transmute(date = as_date(mdy_hm(start_time)),
            player,
            team,
            map = map_name,
            hero,
            stat_name,
            stat_amount,
            stage)

season_2018 <- fs::dir_ls("D:/RProjects/data/overwatch/phs_2018/") %>% 
  set_names("2018_playoffs",
            "2018_stage_1",
            "2018_stage_2",
            "2018-stage_3",
            "2018_stage_4") %>% 
  imap_dfr(~ vroom(.x) %>% mutate(stage = .y)) %>% 
  transmute(date = as_date(mdy_hm(start_time)),
            player,
            team,
            map = map_name,
            hero,
            stat_name,
            stat_amount,
            stage)


bind_rows(season_2018, season_2019, season_2020) %>% 
  vroom_write("D:/RProjects/data/overwatch/fleta_deadlifts.csv")
