express = require 'express'
routes = require './routes'
database = require './database'
middleware = require './middleware'
passport = require './passport'

module.exports = (config) ->

  app = express()

  app.config = config

  database app

  middleware app

  passport app

  routes app

  app
