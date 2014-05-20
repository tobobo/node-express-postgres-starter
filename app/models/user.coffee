RSVP = require 'rsvp'
bcrypt = require 'bcrypt'

module.exports = (app) ->
  Model = require('./model') app
  
  Model.extend
    tableName: 'users'

    hashPassword: ->
      new RSVP.Promise (resolve, reject) =>
        if @changed.password?
          bcrypt.genSalt app.config.salt_work_factor, (err, salt) =>
            if err then reject err
            else
              bcrypt.hash @get('password'), salt, (err, hash) =>
                if err then reject err
                else
                  @set 'password', hash
                  resolve @
        else
          resolve @

    verifyPassword: (candidatePassword) ->
      new RSVP.Promise (resolve, reject) =>
        bcrypt.compare candidatePassword, @get('password'), (err, isMatch) =>
          if err then reject err
          else resolve isMatch

    constructor: ->
      app.db.Model.apply(@, arguments)

      @on 'saving', (model, attrs, options) ->
        model.hashPassword()
