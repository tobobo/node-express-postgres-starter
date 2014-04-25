module.exports = (app) ->
  passport = require 'passport'
  cookieParser = require 'cookie-parser'
  bodyParser = require 'body-parser'
  methodOverride = require 'method-override'
  cookieSession = require 'cookie-session'
  passportBookshelf = require '../strategies/passport_bookshelf'

  app.use cookieParser()
  app.use cookieSession
    secret: app.config.session_key
    key: app.config.session_secret
  app.use bodyParser()
  app.use methodOverride()

  passportBookshelf app

  app.use passport.initialize()
  app.use passport.session()
