config = require('../../config') 'test'
app = require('../../app/app') config
request = require 'supertest'

describe 'routes', ->
  it "should respond at the index with some text", (done) ->
    request(app)
    .get('/')
    .expect(200, 'hello, world', done)
