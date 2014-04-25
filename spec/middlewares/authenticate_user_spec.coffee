config = require('../../config') 'test'
app = require('../../app/app') config
User = require('../../app/models/user') app
_http = require 'express-mocks-http'
authenticateUser = require('../../app/middlewares/authenticate_user') app

describe 'authenticate user middleware', ->
  it 'verifies a user', (done) ->
    password = 'somethingelse'
    user = new User
      email: 'something@whataaa.com'
      password: password
    user.save().then (createdUser) ->
      req = _http.createRequest
        method: 'POST'
        body:
          user:
            email: createdUser.get('email')
            password: password

      req.logIn = (user, options, cb) ->
        @user = user
        cb()

      res = _http.createResponse()

      authenticateUser req, res, ->
        expect(res.content.user.get('email')).toEqual(user.get('email'))
        done()

  it 'does not verify a bad user', (done) ->
    password = 'somethingelsedsf'
    user = new User
      email: 'something@whatafdsdffdaa.com'
      password: password
    user.save().then (createdUser) ->
      req = _http.createRequest
        method: 'POST'
        body:
          user:
            email: createdUser.get('email')
            password: password + "dslkfjlkdsfdkjl"

      res = _http.createResponse()

      res.end = ->
        expect(res.statusCode).toBe(401)
        done()

      authenticateUser req, res, ->

