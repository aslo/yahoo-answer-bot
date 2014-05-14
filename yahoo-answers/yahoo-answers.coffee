request = require 'request'
querystring = require 'querystring'

rootUrl = 'http://answers.yahooapis.com/AnswersService/V1/questionSearch'

params =
  appid: 'awnad732'
  output: 'json'

answers =
  searchQuestions: (query, cb) ->
    params.query = query

    url = rootUrl + '?' + querystring.stringify(params)

    request url, (err, response, body) ->
      cb err, JSON.parse body

module.exports = answers
