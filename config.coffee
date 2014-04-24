db = require './database.json'

module.exports = (env) ->
  env: env
  port: Number(process.env.PORT or 8888)
  salt_work_factor: 10
  session_key: 'postgres_starter_session'
  session_secret: process.env.POSTGRES_STARTER_SESSION_SECRET or 'keyboard cat'
  db: (->
    if db[env]? and db[env].env
      process.env[db[env].env]
    else
      db[env]
  )()
