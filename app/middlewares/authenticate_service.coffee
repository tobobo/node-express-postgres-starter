passport = require 'passport'
url = require 'url'

module.exports = (app) ->
  isValidClient = require('../utils/is_valid_client') app
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
          if isValidClient parsed.host
            if !parsed.query then parsed.query = {}
            if req.user.toJSON?
              user = req.user.toJSON()
            else
              user = req.user

            parsed.query.user = JSON.stringify user
            res.redirect url.format(parsed)

          res.end()
