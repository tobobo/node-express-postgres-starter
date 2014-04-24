module.exports = (app) ->
  User = require('../models/user') app

  (req, res, next) ->
    new User(req.body.user)
    .save().then (user) ->
      req.login user, (err) ->
        res.content = user
        next()
