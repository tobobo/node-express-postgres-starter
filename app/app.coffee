module.exports = (config) ->

  app = require('express')()

  app.config = config

  require('./initializers/database') app

  require('./initializers/middleware') app

  require('./initializers/routes') app

  app
