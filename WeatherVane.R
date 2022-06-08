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

auth <- rtweet_bot(api_key = key_get('WEATHERVANE_TWITTER_API_KEY'),
                   api_secret = key_get('WEATHERVANE_TWITTER_API_SECRET'),
                   access_token = key_get('WEATHERVANE_TWITTER_ACCESS_TOKEN'),
                   access_secret = key_get('WEATHERVANE_TWITTER_ACCESS_SECRET'))
auth_as(auth)

t <- search_tweets(q = 'weather', n = 50, type = 'recent', include_rts = F, geocode = '38.575764,-121.478851,25mi')

today <- Sys.Date()
textdate <- format(today, '%A, %B%e') %>% tolower() %>% stri_replace( '', fixed = ',')

test <- t %>% 
  tibble() %>%
  unnest_tweets(word, full_text, drop = FALSE) %>%
  unnest_ngrams(grams, full_text, drop = FALSE) %>%
  group_by(id_str) %>%
  filter(any(word == 'today') | any(grams == textdate)) %>%
  filter(strftime(created_at, format = '%Y-%m-%d') == Sys.Date()) %>%
  ungroup() %>%
  mutate(word = ifelse('partly' %in% word & word == 'cloudy',
                       'partly',
                       word)) %>%
  inner_join(weatherkey, by = c('word' = 'keywords'), keep = T) 
  
# Find and format high temps  
highs <- test %>%
  filter(grepl('^high of', grams)) %>%
  select(grams) %>% 
  unnest_tokens(char, grams) %>%
  filter(grepl('^[0-9]', char)) %>% 
  deframe() %>%
  stri_replace_all_regex('f', '') %>%
  unique() %>%
  as.numeric() %>%
  sort() %>%
  as.character() %>%
  stri_c('f') %>%
  stri_c(collapse = ' or ')

# Find and format low temps
lows <- test %>%
  filter(grepl('^low of', grams)) %>%
  select(grams) %>% 
  unnest_tokens(char, grams) %>%
  filter(grepl('^[0-9]', char)) %>%
  deframe() %>%
  stri_replace_all_regex('f', '') %>%
  unique() %>%
  as.numeric() %>%
  sort() %>%
  as.character() %>%
  stri_c('f') %>% 
  stri_c(collapse = ' or ')
  
# Generate message  
test %>%  
  select(types) %>%
  unique() %>%
  deframe() %>%
  stri_c( collapse = ' or ') %>%
  paste0('Twitter says Sacramento area\'s weather today is ',
         .,
         ', with possible highs of ',
         highs,
         ' and possible lows of ',
         lows,
         '.') %>%
  print()
 









