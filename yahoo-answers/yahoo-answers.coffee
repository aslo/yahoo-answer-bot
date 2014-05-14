request = require 'request'
querystring = require 'querystring'

conf = require '../conf.coffee'

rootUrl = 'http://answers.yahooapis.com/AnswersService/V1/questionSearch'

params =
  appid: conf.yahoo_app_id
  output: 'json'

answers =
  searchQuestions: (query, cb) ->
    params.query = query

    url = rootUrl + '?' + querystring.stringify(params)

    request url, (err, response, body) ->
      parsedResponse = undefined
      try
        parsedResponse = JSON.parse body
      catch e
        console.log 'error parsing yahoo response body:', body
        return cb e

      cb null, parsedResponse

module.exports = answers
