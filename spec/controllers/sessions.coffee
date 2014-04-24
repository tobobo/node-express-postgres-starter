config = require('../../config') 'test'
app = require('../../app/init') config
User = require('../../app/models/user') app
request = require 'supertest'

describe 'sessions controller', ->
  it "should log a user in", (done) ->
    password = 'summat'
    new User
      email: 'someothing'
      password: password
    .save().then (createdUser) ->
      request(app)
      .post('/sessions')
      .send
        email: createdUser.get('email')
        password: password
      .expect(200, done)

  it "should not log a user in without credentials", (done) ->
    request(app)
    .post('/sessions')
    .expect(400, done)

