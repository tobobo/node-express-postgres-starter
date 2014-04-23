routes = require '../app/routes.coffee'
httpMocks = require 'express-mocks-http'

describe 'routes', ->
  it "should respond at the index with some text", (done) ->
    url = '/'
    req = httpMocks.createRequest
      method: 'GET'
      url: url
    res = httpMocks.createResponse()
    app =
      get: (route, fn) ->
        if route == url
          fn req, res
          expect res._getData().length
            .toBeGreaterThan(0)
          done()
          
    routes app
