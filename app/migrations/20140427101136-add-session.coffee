dbm = require 'db-migrate'
type = dbm.dataType

exports.up = (db, callback) ->
  db.createTable "session",
    sid:
      type: "string"
      primaryKey: true
      notNull: true
    sess:
      type: "string"
      notNull: true
    expire:
      type: "date"
      notNull: true
  , callback

exports.down = (db, callback) ->
  db.dropTable 'session', callback

