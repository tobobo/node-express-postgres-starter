module.exports = (app) ->
  passport = require 'passport'

  app.get '/', (req, res) ->
    res.send 'hello, world'

  require('../routes/sessions') app
  require('../routes/users') app
