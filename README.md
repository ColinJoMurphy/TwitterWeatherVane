# Tell The Weather With Twitter!

This is a web app that uses data from twitter to report the daily weather. The weather is posted to a twitter account [here](https://twitter.com/tweet_vane). 

I ran into trouble when trying to authorize the app for the bot account. After trying a few different iterations of a 3-legged OAuth flow to get access to the bot 
account's access tokens, I found [this python suggestion](https://gist.github.com/moonmilk/035917e668872013c1bd?permalink_comment_id=1333900#gistcomment-1333900) by 
[beaugunderson](https://gist.github.com/beaugunderson) that uses the `tweepy` package. The GetTwitterOauthCredentials.py is the updated version I made to get access credentials for my weather bot.
