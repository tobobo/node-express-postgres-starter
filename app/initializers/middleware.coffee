module.exports = (app) ->
  passport = require 'passport'
  cookieParser = require 'cookie-parser'
  bodyParser = require 'body-parser'
  methodOverride = require 'method-override'
  passportBookshelf = require '../strategies/passport_bookshelf'
  expressSession = require 'express-session'
  fauxConnect =
    session: expressSession
  PgSession = require('connect-pg-simple') fauxConnect

  app.use cookieParser()

  app.use fauxConnect.session
    secret: app.config.session_key
    key: app.config.session_secret
    cookie:
      maxAge: 30*24*60*60*1000
    store: new PgSession
      conString: ((dbC) -> [
        "postgres://",
        "#{dbC.user}",
        "#{if dbC.password? then ":" + dbC.password else ""}",
        "@#{dbC.host}",
        "#{if dbC.port? then ":" + dbC.port else ""}",
        "/#{dbC.database}"
      ].join '') app.db.knex.client.connectionSettings
  app.use bodyParser()
  app.use methodOverride()

  passportBookshelf app

  app.use passport.initialize()
  app.use passport.session()
