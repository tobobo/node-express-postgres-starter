app =
  config:
    clients: ['localhost']
isValidClient = require('../../app/utils/is_valid_client') app

describe 'Client validator', ->

  it 'should validate a valid client', ->
    expect(isValidClient(app.config.clients[0])).toBe true

  it 'should return false for an invalid client', ->
    expect(isValidClient('blahblah.com')).toBe false
