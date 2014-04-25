config = require('../../config') 'test'
app = require('../../app/app') config
getCurrentUser = require('../../app/middlewares/get_current_user') app
User = require('../../app/models/user') app
_http = require 'express-mocks-http'

describe 'get current user middleware', ->
  it 'should get the current user', (done) ->
    req = _http.createRequest()
    res = _http.createResponse()
    req.user = new User
      email: 'hella@what.where'
      password: 'fly'
    getCurrentUser req, res, ->
      expect(res.content[0].user.get('email')).toEqual(req.user.get('email'))
      done()
