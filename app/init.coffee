express = require 'express'
routes = require './routes'
database = require './database'

module.exports = (config) ->

  app = express()

  app.config = config

  database app

  routes app

  app
