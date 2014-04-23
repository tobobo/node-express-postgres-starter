RSVP = require 'rsvp'

module.exports = (app) ->
  User = app.db.Model.extend
    tableName: 'users'

    constructor: ->
      app.db.Model.apply(this, arguments)

      this.on 'saving', (model, attrs, options) ->
        new RSVP.Promise (resolve, reject) ->
          resolve()

  User
