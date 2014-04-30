passport = require 'passport'
url = require 'url'

module.exports = (app) ->
  (strategy) ->
    auth: (req, res) ->
      req.session.authCallbackURL = req.query.callback
      passport.authenticate(strategy) req, res

    callback: (req, res) ->
      passport.authenticate(strategy) req, res, ->
        if req.session.authCallbackURL?
          cbURL = req.session.authCallbackURL
          delete req.session.authCallbackURL
          parsed = url.parse cbURL
          if !parsed.query then parsed.query = {}
          parsed.query.user = JSON.stringify req.user
          res.redirect url.format(parsed)
          
        res.end()
