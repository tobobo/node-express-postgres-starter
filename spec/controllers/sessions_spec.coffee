config = require('../../config') 'test'
app = require('../../app/app') config
User = require('../../app/models/user') app
request = require 'supertest'

describe 'sessions controller', ->

    it "should not log a user in without credentials", (done) ->
      request(app)
      .post('/sessions')
      .expect(400, done)

    email = 'someothing@wut.com'
    password = 'summat'
    req = null

    agent = request.agent(app)
    it "should log a user in", (done) ->
      new User
        email: email
        password: password
      .save().then (createdUser) ->
        agent
        .post('/sessions')
        .send
          session:
            email: createdUser.get('email')
            password: password
        .expect('set-cookie', /.*/)
        .expect(new RegExp("#{email}"))
        .expect(200, done)

    it "should get the current user", (done) ->
      agent
      .get('/sessions')
      .expect(new RegExp("#{email}"), done)

    it "should log a user out", (done) ->
      agent.delete('/sessions').expect(/logged out/, done)

    it "should not have a user anymore", (done) ->
      agent
      .get('/sessions')
      .expect(/no current user/i, done)

