module.exports = (app) ->
  passport = require 'passport'

  app.get '/', (req, res) ->
    res.send 'hello, world'

  require('../controllers/sessions') app
  require('../controllers/users') app
