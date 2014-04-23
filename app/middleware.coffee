module.exports = (app) ->
  express = require 'express'
  cookieParser = require 'cookie-parser'
  bodyParser = require 'body-parser'
  methodOverride = require 'method-override'

  app.use cookieParser()
  app.use bodyParser()
  app.use methodOverride()
