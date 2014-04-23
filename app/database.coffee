Bookshelf = require 'bookshelf'

module.exports = (app) ->
  app.db = Bookshelf.initialize
    client: 'pg'
    connection:
      host: app.config.db.host
      user: app.config.db.user
      password: app.config.db.password
      database: app.config.db.database
