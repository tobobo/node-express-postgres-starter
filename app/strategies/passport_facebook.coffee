module.exports = (app) ->
  passport = require 'passport'
  FacebookStrategy = require('passport-facebook').Strategy
  User = require('../models/user') app
  RSVP = require 'rsvp'

  passport.use new FacebookStrategy
    clientID: app.config.facebook_app_id
    clientSecret: app.config.facebook_app_secret
    callbackURL: '/auth/facebook/callback'
    passReqToCallback: true
  , (req, accessToken, refreshToken, profile, done) ->
    done null, profile
