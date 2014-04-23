module.exports = (app) ->
  User = app.db.Model.extend
    tableName: 'users'

  User
