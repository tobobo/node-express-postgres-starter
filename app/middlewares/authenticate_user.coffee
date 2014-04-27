module.exports = (app) ->
  passport = require 'passport'

  (req, res, next) ->
    if req.body.session
      req.body.email = req.body.session.email
      req.body.password = req.body.session.password

    passport.authenticate('local') req, res, ->
      res.content = 
        user: req.user
      next()
    return
