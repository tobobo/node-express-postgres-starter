module.exports = (app) ->
  passport = require 'passport'
  LocalStrategy = require('passport-local').Strategy
  User = require('./models/user') app
  RSVP = require 'rsvp'

  passport.serializeUser (user, done) ->
    done null, user.id

  passport.deserializeUser (id, done) ->
    new User
      id: id
    .fetch().then (user) ->
      done null, user
    , (error) ->
      done error

  passport.use new LocalStrategy
    usernameField: 'email'
  , (email, password, done) ->
    user = null
    new User
      email: email
    .fetch().then (foundUser) ->
      if foundUser?
        user = foundUser
        user.verifyPassword(password)
      else
        RSVP.reject()
    .then (isMatch) ->
      if isMatch then RSVP.resolve user
      else RSVP.reject()
    .then (user) ->
      done null, user
    , ->
      done null, false,
        message: 'Invalid password'


  app.use passport.initialize()
  app.use passport.session()
