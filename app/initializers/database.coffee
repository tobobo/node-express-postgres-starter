Bookshelf = require 'bookshelf'

module.exports = (app) ->
  app.db = Bookshelf.initialize
    client: 'pg'
    connection:
      host: app.config.db[app.config.env].host
      user: app.config.db[app.config.env].user
      password: app.config.db[app.config.env].password
      database: app.config.db[app.config.env].database
