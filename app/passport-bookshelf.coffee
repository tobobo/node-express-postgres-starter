module.exports = (app) ->
  passport = require 'passport'
  LocalStrategy = require('passport-local').Strategy

  passport.serializeUser (user, done) ->
    done null, user.id

  passport.deserializeUser (id, done) ->
    id: id

  passport.use new LocalStrategy
    usernameField: 'email'
  , (email, password, done) ->
    done null,
      id: 1
      email: email

  app.use passport.initialize()
