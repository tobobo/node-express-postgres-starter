config = require('../../config') 'test'
app = require('../../app/init') config
createUser = require('../../app/middlewares/create_user') app
_http = require 'express-mocks-http'

describe 'create user middleware', ->
  it 'should create a user', (done) ->
    email = 'who@me.com'
    password = 'wutwutwutwut'
    req = _http.createRequest
      body:
        user:
          email: email
          password: password

    res = _http.createResponse()

    req.login = (user, cb) ->
      expect(user.get('email')).toEqual(email)
      expect(user.get('id')?).toBe(true)
      cb()

    createUser req, res, ->
      expect(res.content.get('email')).toEqual(email)

      done()
