config = require('../config.coffee') 'test'
app = require('../app/init.coffee') config
request = require 'supertest'

describe 'routes', ->
  it "should respond at the index with some text", (done) ->
    request(app)
    .get('/')
    .expect(200, 'hello, world', done)
