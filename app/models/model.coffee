S = require 'string'

module.exports = (app) ->
  
  filterKeys = (attrs, fn) ->
    memo = {}
    for k, v of attrs
      memo[fn(k)] = v
    memo

  app.db.Model.extend

    format: (attrs) ->
      filterKeys attrs, (k) -> S(k).underscore().s

    parse: (attrs) ->
      filterKeys attrs, (k) -> S(k).camelize().s
