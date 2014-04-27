config = require('../../config') 'test'
app = require('../../app/app') config
render = require('../../app/middlewares/render') app
User = require('../../app/models/user') app

describe 'render middleware', ->

  it 'should render an object', (done) ->
    _http = require 'express-mocks-http'
    req = _http.createRequest()
    res = _http.createResponse()
    res.content = 
      what: 'hey'
      now: 'there'

    key = 'objKey'

    res.send = (object) ->
      expect('meta' of object).toBe(true)
      expect(key of object).toBe(true)
      done()

    render(key) req, res

  it 'should render a model', (done) ->
    _http = require 'express-mocks-http'
    req = _http.createRequest()
    res = _http.createResponse()
    res.content = new User
      email: 'hwehlkjsdf@what.com'
      password: 'sdlkfdsjlk@sldfkj.com'

    key = 'user'

    res.send = (object) ->
      expect('meta' of object).toBe(true)
      expect(key of object).toBe(true)
      expect('email' of object[key]).toBe(true)
      done()

    render(key) req, res

  it 'should render many objects', (done) ->
    _http = require 'express-mocks-http'
    req = _http.createRequest()
    res = _http.createResponse()
    res.content = [
      what: 'hey'
      hey: 'there'
    ,
      what: 'ugh'
      hey: 'you'
    ]

    key = 'users'

    res.send = (object) ->
      expect('meta' of object).toBe(true)
      expect(key of object).toBe(true)
      expect(object[key].length).toBe(2)
      expect('what' of object[key][0]).toBe(true)
      done()

    render(key) req, res

  it 'should render many models', (done) ->
    _http = require 'express-mocks-http'
    req = _http.createRequest()
    res = _http.createResponse()
    res.content = [
      new User
        email: 'hwehlkjsdf@what.com'
        password: 'sdlkfdsjlk@sldfkj.com'
    ,
      new User
        email: 'sfsfsfs@what.com'
        password: 'sdlkfddddddddsjlk@sldfkj.com'
    ]

    key = 'users'

    res.send = (object) ->
      expect('meta' of object).toBe(true)
      expect(key of object).toBe(true)
      expect(object[key].length).toBe(2)
      expect('email' of object[key][0]).toBe(true)
      done()

    render(key) req, res

  it 'should render nothing', (done) ->
    _http = require 'express-mocks-http'
    req = _http.createRequest()
    res = _http.createResponse()

    key = 'users'

    res.send = (object) ->
      expect('meta' of object).toBe(true)
      expect(key of object).toBe(true)
      done()

    render(key) req, res

  it 'should render meta', (done) ->
    _http = require 'express-mocks-http'
    req = _http.createRequest()
    res = _http.createResponse()

    res.meta = "some meta"

    key = 'users'

    res.send = (object) ->
      expect('meta' of object).toBe(true)
      expect(object.meta).toEqual(res.meta)
      done()

    render(key) req, res

