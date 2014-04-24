dbm = require("db-migrate")
type = dbm.dataType

exports.up = (db, callback) ->
  db.createTable "users",
    id:
      type: "int"
      primaryKey: true
      autoIncrement: true
    email:
      type: "string"
      notNull: true
    password:
      type: "string"
      notNull: true
    salt: "string"
  , callback

exports.down = (db, callback) ->
  db.dropTable "users", callback
