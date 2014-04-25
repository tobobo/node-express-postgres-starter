module.exports = (app) ->
  passport = require 'passport'

  (req, res, next) ->
    if req.body.user
      req.body.email = req.body.user.email
      req.body.password = req.body.user.password

    passport.authenticate('local') req, res, ->
      res.content = 
        user: req.user
      next()
    return
