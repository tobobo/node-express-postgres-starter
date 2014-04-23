app = 
  config: require('../../config.coffee') 'test'

require('../../app/database') app
User = require('../../app/models/user') app

describe 'user', ->
  it 'can be created', (done) ->
    new User
      email: 'hey'
    .save().then (model) ->
      expect(model.id).not.toBeNull()
      done()

  it 'can be found by id', (done) ->
    new User
      email: 'something'

    .save().then (createdUser) ->
      new User({id: createdUser.id}).fetch().then (foundUser) ->
        expect(foundUser.id)
          .toEqual createdUser.id
        done()
