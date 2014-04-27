config = require('../../config') 'test'
app = require('../../app/app') config
User = require('../../app/models/user') app
request = require 'supertest'

describe 'users controller', ->
  it "should create a user", (done) ->
    request(app)
    .post('/users')
    .send
      user:
        email: 'hoohah@what.com'
        password: 'passpass'
    .expect(200, done)
