express = require 'express'
routes = require './routes'
database = require './database'
middleware = require './middleware'
passportBookshelf = require './passport-bookshelf'

module.exports = (config) ->

  app = express()

  app.config = config

  database app

  middleware app

  passportBookshelf app

  routes app

  app
