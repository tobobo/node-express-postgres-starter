module.exports = (app) ->
  express = require 'express'
  cookieParser = require 'cookie-parser'
  bodyParser = require 'body-parser'
  methodOverride = require 'method-override'
  cookieSession = require 'cookie-session'

  app.use cookieParser()
  app.use cookieSession
    secret: app.config.session_key
    key: app.config.session_secret
  app.use bodyParser()
  app.use methodOverride()
