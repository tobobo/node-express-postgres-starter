module.exports = (app) ->
  passport = require 'passport'

  app.post '/sessions', passport.authenticate('local'), (req, res) ->
    res.send 'wow!'
