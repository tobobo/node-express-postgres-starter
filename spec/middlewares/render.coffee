config = require('../../config') 'test'
app = require('../../app/init') config
render = require('../../app/middlewares/render.coffee') app
User = require('../../app/models/user.coffee') app

describe 'render middleware', ->

  it 'renders an object', (done) ->
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

  it 'renders a model', (done) ->
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

  it 'renders many objects', (done) ->
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

  it 'renders many models', (done) ->
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
