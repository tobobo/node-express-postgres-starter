app =
  config: require('../../config') 'test'
require('../../app/initializers/database') app
User = require('../../app/models/user') app

describe 'user', ->
  it 'should be createable', (done) ->
    new User
      email: 'hey',
      password: 'hey'
    .save().then (model) ->
      expect(model.id).not.toBeNull()
      done()

  it 'can be found by id', (done) ->
    new User
      email: 'something',
      password: 'summat'
    .save().then (createdUser) ->
      new User({id: createdUser.id}).fetch().then (foundUser) ->
        expect(foundUser.id)
          .toEqual createdUser.id
        done()

  describe 'password hashing', ->
    password = 'wuddat'
    user = new User
      email: 'hey'
      password: password

    it 'can hash a password', (done) ->
      user.hashPassword().then (user) ->
        expect(user.get('password'))
        .not.toEqual password
        done()

    it 'can verify a password', (done) ->
      user.verifyPassword(password)
      .then (isMatch) ->
        expect(isMatch).toBe(true)
        done()

    it 'does not verify a bad password', (done) ->
      user.verifyPassword(password + "gooble")
      .then (isMatch) ->
        expect(isMatch).toBe(false)
        done()

    password = 'gibblies'
    user = new User
      email: 'wutz',
      password: password

    hashed = null

    it 'hashes a password automatically on save', (done) ->
      user.save().then (user) ->
        hashed = user.get('password')
        expect(user.get('password'))
          .not.toEqual password
        done()

    it 'does not hash a password if the password was not changed', (done) ->
      user.set 'email', 'somethingelse@what.com'
      user.save().then (user) ->
        expect(user.get('password'))
          .toEqual hashed
        done()
