library(rtweet)
library(httpuv)
library(tidytext)
library(dplyr)
library(tibble)
library(stringi)

keywords <- c('sunny', 
           'sunshine',
           'partly',
           'cloudy', 
           'overcast', 
           'rainy', 
           'rain', 
           'raining', 
           'showers',
           'snow',
           'snowing',
           'snowy',
           'windy', 
           'foggy',
           'thunder and lighting')

types <- c('Sunny',
           'Sunny',
           'Partly Cloudy',
           'Cloudy',
           'Overcast',
           'Rainy',
           'Rainy',
           'Rainy',
           'Showers',
           'Snowy',
           'Snowy',
           'Snowy',
           'Windy',
           'Foggy',
           'Thunder and Lighting'
           )

weatherkey <- tibble(keywords, types)


t <- search_tweets('weather', n = 40, include_rts = F, geocode = '38.575764,-121.478851,25mi')

today <- Sys.Date()
textdate <- format(today, '%A, %B %d') %>% tolower()

t %>% 
  unnest_tweets(word, text, drop = FALSE) %>%
  unnest_ngrams(grams, text, drop = FALSE) %>%
  group_by(user_id, status_id) %>%
  filter(any(word == 'today') | any(grams == textdate)) %>%
  filter(strftime(created_at, format = '%Y-%m-%d') == Sys.Date()) %>%
  ungroup() %>%
  mutate(word = ifelse('partly' %in% word & word == 'cloudy',
                       'partly',
                       word)) %>%
  inner_join(weatherkey, by = c('word' = 'keywords'), keep = T) %>%
  select(types) %>%
  unique() %>%
  deframe() %>%
  stri_c( collapse = ' or ') %>%
  paste0('Twitter says today\'s weather is ', .) %>%
  print()
 









