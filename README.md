[![WeatherVaneBot](https://github.com/ColinJoMurphy/TwitterWeatherVane/actions/workflows/WeatherVaneBot.yml/badge.svg)](https://github.com/ColinJoMurphy/TwitterWeatherVane/actions/workflows/WeatherVaneBot.yml)

# Twitter Weather Vane

This project is a Twitter bot build that tells the local weather based on local tweets. The bot pulls Sacramento, CA area tweets containing the word 'weather' from
Twitter. Some light text analysis is done to subset out tweets that refer to common weather forecast terms and the current date. Then, a message containing the
forecasts (including temperature highs and lows) is generated and posted to the bot's twitter account [here](https://twitter.com/tweet_vane). 

This project's main script is written in R and uses the following packages:
- `rtweet` wraps the Twitter API in useful and easy to use R functions
- `dplyr` for tidyverse style data manipulation, e.g. select(), filter(), mutate(), and %>% (piping)
- `tidytext` for text analysis using tidy data principles
- `stringi` for string manipulation
- `pak` for loading the most up to date package of `rtweet` from a [ropensci's github](https://github.com/ropensci/rtweet)
  
The python script is used to get the access credentials to a third party Twitter acount, in this case, the bot's account. More about the python script can be found in
the ***Hurdles*** section. This script use the modules:
- `tweepy` to handle 3-legged OAuth authorization

## Instructions to Make Your Own Twitter Bot:
Prerequisites:
- Twitter Developer account
- Twitter account you'd like your bot to post to (doesn't need to the same account as the Twitter Developer account)
- A way to run a Python 3 script on your machine
- An R script that accesses the Twitter API and does whatever you want your bot to do

1. Create a **Standalone** app using the Twitter Developer Portal with your Twitter Developer account. Note that if you don't create a Standalone app and instead make an app that lives inside a project, you will need to apply for 'Elevated' status for the project. This is because the R package `rtweet` uses Twitter API v1 and projects can only us Twitter API v2 unless they are granted 'Elevated' status.
2. Within the app you just created, edit the authentication settings:
  - Set **App permissions** correctly for your app depending whether R script reads only; reads and writes; or reads, writes, and accesses direct messages
  - Set the **Callback URI** to `http://127.0.0.1`
  - Set the **Website URL** to whatever you'd like; I set mine to the bot's Twitter page 

4. Fork this repository.
5. Add your app's API token and secret to your repository as **Repository Secrets**.
6. Log into the bot's Twitter account via your browser.
7. Use the [GetTwitterOauthCredentials.py](https://github.com/ColinJoMurphy/TwitterWeatherVane/blob/e7dab57e71c0dcb7a4bf34607d23b7024d7179f3/GetTwitterOauthCredentials.py) with your apps consumer API token and secret to get the access token and secret for your bot's Twitter account.






## Hurdles
The following section outlines the major challenges I faced during this project and what I did to work around them.

1. I ran into trouble when trying to authorize the app for the bot account. After trying a few different iterations of a 3-legged OAuth flow to get access to the bot 
account's access tokens, I found [this python suggestion](https://gist.github.com/moonmilk/035917e668872013c1bd?permalink_comment_id=1333900#gistcomment-1333900) by 
[beaugunderson](https://gist.github.com/beaugunderson) that uses the `tweepy` package. The GetTwitterOauthCredentials.py is the updated version I made to get access credentials for my weather bot.
