express = require 'express'
routes = require('./routes')

module.exports = (config) ->

  app = express()

  app.config = config

  routes app
  
  app
