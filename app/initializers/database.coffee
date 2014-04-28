Bookshelf = require 'bookshelf'
parseUrl = require 'parse-database-url'

module.exports = (app) ->
  dbConfig = app.config.db

  connection = if dbConfig.host?
    result = {}
    for param in ['host', 'user', 'password', 'database', 'port']
      result[param] = dbConfig[param]
    result
  else
    parseUrl dbConfig

  app.db = Bookshelf.initialize
    client: 'pg'
    connection: connection
