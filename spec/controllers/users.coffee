config = require('../../config') 'test'
app = require('../../app/init') config
User = require('../../app/models/user') app
request = require 'supertest'

describe 'users controller', ->
  it "should create a user", (done) ->
    password = 'summat'
    new User
      email: 'someothing'
      password: password
    .save().then (createdUser) ->
      request(app)
      .post('/users')
      .send
        user:
          email: createdUser.get('email')
          password: password
      .expect(200, done)
