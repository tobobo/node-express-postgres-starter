db = require './database.json'

module.exports = (env) ->
  if db[env]? and db[env].env
    db = process.env[db[env].env]
  else
    db = db[env]
  port: Number(process.env.PORT or 9000)
  env: env
  db: db
