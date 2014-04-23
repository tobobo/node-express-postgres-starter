module.exports = (app) ->
  passport = require 'passport'
  app.get '/', (req, res) -> res.send 'hello, world'

  app.post '/sessions/new', passport.authenticate('local'), (req, res) ->
    console.log 'req user', req.user
    res.send 'sessions new' 
