db = require './database.json'

module.exports = (env) ->
  env: env
  port: Number(process.env.PORT or 8888)
  db: (->
    if db[env]? and db[env].env
      process.env[db[env].env]
    else
      db[env]
  )()
