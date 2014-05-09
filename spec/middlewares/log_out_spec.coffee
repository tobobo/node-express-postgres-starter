app =
  config: require('../../config') 'test'
require('../../app/initializers/database') app
_http = require 'express-mocks-http'
logOut = require('../../app/middlewares/log_out') app

describe 'log out middleware', ->
  it 'logs a user out', (done) ->
    req = _http.createRequest
      session: 'blahblah'
      user: 'blahblah'
    res = _http.createResponse()

    req.logOut = ->
      done()

    logOut req, res, ->
      expect(!req.user).toBe(true)
