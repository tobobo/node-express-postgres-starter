module.exports = (app) ->
  passport = require 'passport'
  LocalStrategy = require('passport-local').Strategy

  passport.serializeUser (user, done) ->
    console.log 'user', user
    done null, user.id

  passport.deserializeUser (id, done) ->
    id: id

  passport.use new LocalStrategy (email, password, done) ->
    done null,
      id: 1
      email: email
    return

  app.use passport.initialize()
