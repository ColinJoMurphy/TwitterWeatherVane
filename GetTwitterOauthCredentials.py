#!/usr/bin/env python

import tweepy

# From your app settings page
CONSUMER_KEY = "YOUR_API_KEY_HERE"
CONSUMER_SECRET = "YOUR_API_SECRET_HERE"

auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET, callback = 'oob')
auth.secure = True
auth_url = auth.get_authorization_url()

print ('Please authorize: ' + auth_url)

verifier = input('PIN: ').strip()

auth.get_access_token(verifier)

print ("ACCESS_KEY = " + auth.access_token)
print ("ACCESS_SECRET = " +  auth.access_token_secret)

