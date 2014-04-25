Bookshelf = require 'bookshelf'
parseUrl = require 'parse-database-url'

module.exports = (app) ->
  dbConfig = app.config.db[app.config.env]

  processParam = (param) ->
    if param?
      if param.ENV?
        process.env[param.ENV]
      else
        param

  connection = if dbConfig.host?
    result = {}
    for param in ['host', 'user', 'password', 'database', 'port']
      result[param] = processParam dbConfig[param]
    result
  else
    parseUrl processParam(dbConfig)

  app.db = Bookshelf.initialize
    client: 'pg'
    connection: connection
