app =
  config: require('../../config') 'test'
require('../../app/initializers/database') app
User = require('../../app/models/user') app
_http = require 'express-mocks-http'
passport = require 'passport'

describe 'passport bookshelf login', ->
  it 'verifies a user', (done) ->
    password = 'somethingelse'
    user = new User
      email: 'something@what.com'
      password: password
    user.save().then (createdUser) ->
      req = _http.createRequest
        method: 'POST'
        body:
          email: createdUser.get('email')
          password: password

      req.logIn = (user, options, cb) ->
        done()
        cb()

      res = _http.createResponse()

      next = ->

      passport.authenticate('local') req, res, next

  it 'does not verify a bad user', (done) ->
    password = 'somethingelsewhat'
    user = new User
      email: 'something@whatddd.com'
      password: password
    user.save().then (createdUser) ->
      req = _http.createRequest
        method: 'POST'
        body:
          email: createdUser.get('email')
          password: password + 'goober'

      res = _http.createResponse()
      res.end = ->
        expect(res.statusCode).toEqual(401)
        done()

      passport.authenticate('local') req, res
