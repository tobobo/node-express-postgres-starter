module.exports = (app) ->
  User = require('../models/user') app

  app.post '/users', (req, res) ->
    new User(req.body.user)
    .save().then (user) ->
      req.login user, (err) ->
        res.send 
          user: user.toJSON()
