# Yahoo Answer Bot


A Twitter bot that responds to publicly tweeted questions with answers from the Yahoo Answers API

## Getting Started
Create a file called `conf.coffee` which exports your twitter configuration parameters, i.e.

```
module.exports =
  consumer_key: TWITTER_CONSUMER_KEY
  consumer_secret: TWITTER_CONSUMER_SECRET
  access_token: TWITTER_ACCESS_TOKEN
  access_token_secret: TWITTER_ACCESS_TOKEN_SECRET
```

## The Blacklist
To prevent the bot from tweeting certain 'blacklisted' words, add a file called `blacklist.coffee` (gitignored by default). The bot checks this list before it tweets, so if you want yahoo-answer-bot to keep it clean, this is the best way to do it.  The bot also works just fine without it.