# Yahoo Answer Bot 

A Twitter bot that responds to publicly tweeted questions with answers from the Yahoo Answers API. 

Check me out [@bad_advice_bot](https://twitter.com/bad_advice_bot)

## Getting Started
Create a file called `conf.coffee` at the project root which exports your configuration parameters for the yahoo and twitter API's, i.e.

```
module.exports =
  yahoo_app_id: YAHOO_APP_ID
  consumer_key: TWITTER_CONSUMER_KEY
  consumer_secret: TWITTER_CONSUMER_SECRET
  access_token: TWITTER_ACCESS_TOKEN
  access_token_secret: TWITTER_ACCESS_TOKEN_SECRET
```

### Running it
```
// install coffeescript
npm install -g coffeescript

// install dependencies
cd yahoo-answer-bot && npm install

coffee main.coffee
```

### The Blacklist
To prevent the bot from tweeting certain 'blacklisted' words, add a file called `blacklist.coffee` (gitignored by default). The bot checks this list before it tweets, so if you want yahoo-answer-bot to keep it clean, this is the best way to do it.  The bot also works just fine without it.