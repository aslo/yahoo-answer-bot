Step     = require 'step'
Twit     = require 'twit'
Yahoo    = require './yahoo-answers/yahoo-answers'

conf = require './conf.coffee'

# include an optional blacklist to prevent the bot from being racist, etc.
blacklist =
  try
    require './blacklist'
  catch e
    []

keywords = [
  'how do girls'
  'how do boys'
  'how are girls'
  'how are boys'
  'why do girls'
  'why do boys'
  'why are girls'
  'why are boys'
  'why does my boyfriend'
  'why does my girlfriend'
]

twit = new Twit conf
stream = twit.stream 'statuses/filter', { track: keywords.join(',') }

queue = []

parseTweet = (tweetBody) ->
  tweet = tweetBody.toLowerCase()

  # isolate relevant question sentence
  for key in keywords
    if (start = tweet.indexOf key) > -1
      break

  # end of question is a question mark or just the end of the tweet
  end = tweet.indexOf '?'
  if end is -1
    end = tweet.length - 1

  if start > -1 and end > -1
    question = tweet.substring start, end + 1
  else
    # not a complete question
    return null

  # remove @mentions and #hashtags
  tokens = question.split ' '
  for token, i in tokens
    # remove '#' character, but keep hashtag words
    if token.charAt(0) is '#'
      token = token.substring 1
    # remove @usernames
    if token.charAt(0) is '@'
      tokens[i] = undefined

  # reassemble the question
  return tokens.join ' '

stream.on 'tweet', (tweet) ->
  tweeterName = '@' + tweet.user.screen_name

  Step(
    ->
      # skip if this is a retweet
      if tweet.retweeted_status?
        return @ null, null

      question = parseTweet tweet.text

      if question?
        Yahoo.searchQuestions question, @
      else
        @ null, null

      return
    (err, response) ->
      if err or not response?
        console.log 'Could not proceed with response from yahoo', err, response
        return null

      # assume the first yahoo question returned is the best match
      if response?.all?.questions[0]?.ChosenAnswer?
        rawAnswer = response?.all?.questions[0]?.ChosenAnswer

        # after including the tweeter's handle (and a space),
        # the max chars we have for the rest of the tweet
        maxTweetLength = 140 - tweeterName.length - 1

        # compose a tweetable response
        lastPeriod = -1
        for char, j in rawAnswer.substr 0, maxTweetLength
          if char is '.'
            lastPeriod = j

        return if lastPeriod < 0

        answer = tweeterName + ' ' + rawAnswer.substring(0, lastPeriod + 1)

        # bad words are bad!
        for badWord in blacklist
          if answer.toLowerCase().indexOf(badWord) isnt -1
            return

        console.log 'Original tweet was: ', tweet.text
        console.log 'Response tweet is: ', answer
        console.log ''

        queue.push
          replyTo: tweet.id_str
          tweet: answer

        # just an arbitrary size limit
        if queue.length > 200
          console.log 'Queue is full. Removing the oldest tweet to make room'
          queue.shift()
  )

# every 5 minutes, pop from the queue
setInterval( ->
  data = queue.shift()

  if data?
    twit.post 'statuses/update', {
      status: data.tweet
      in_reply_to_status_id: data.replyTo
    }, (err, result) ->
      if err?
        console.log 'Error tweeting!', err.message
      else
        console.log 'Tweeted', result.text

, 1000*60*5)
