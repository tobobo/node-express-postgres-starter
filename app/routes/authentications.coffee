module.exports = (app) ->
  passport = require 'passport'
  url = require 'url'

  app.get '/auth/facebook', (req, res) ->
    req.session.authCallbackURL = req.query.callback
    passport.authenticate('facebook') req, res

  app.get '/auth/facebook/callback', passport.authenticate('facebook'), (req, res) ->
    if req.session.authCallbackURL?
      cbURL = req.session.authCallbackURL
      delete req.session.authCallbackURL
      parsed = url.parse cbURL
      if !parsed.query then parsed.query = {}
      parsed.query.user = JSON.stringify req.user
      res.redirect url.format(parsed)
    res.end()
