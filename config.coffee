module.exports = (env) ->
  appName = 'postgres_starter'

  env: env
  port: Number(process.env.PORT or 8888)
  salt_work_factor: 10
  session_key: "#{appName}_session"
  session_secret: process.env["#{appName.toUpperCase()}_SESSION_SECRET"] or 'keyboard cat'
  db: 
    dev:
      driver: "pg",
      user: "#{appName}_dev",
      host: "localhost",  
      database: "#{appName}_dev"
    test:
      driver: "pg",
      user: "#{appName}_test",
      host: "localhost",
      database: "#{appName}_test"
    prod: process.env["#{appName.toUpperCase()}_DB_URL"]
