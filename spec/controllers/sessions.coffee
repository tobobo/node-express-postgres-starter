config = require('../../config.coffee') 'test'
app = require('../../app/init.coffee') config
request = require 'supertest'

describe 'sessions controller', ->
  it "should log a user in", (done) ->
    request(app)
    .post('/sessions')
    .send
      email: 'blah'
      password: 'blah'
    .expect(200, done)

  it "should not log a user in without credentials", (done) ->
    request(app)
    .post('/sessions')
    .expect(400, done)

