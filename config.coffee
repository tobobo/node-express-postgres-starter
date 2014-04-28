module.exports = (env) ->
  appName = 'postgres_starter'
  port = process.env.PORT or 8888

  env: env
  appName: appName
  port: port
  salt_work_factor: 10
  sessionKey: "#{appName}_session"
  sessionSecret: process.env["#{appName.toUpperCase()}_SESSION_SECRET"] or 'keyboard cat'
  url: (->
    if env == 'prod'
      "http://#{appName}_server.herokuapp.com"
    else
      "http://localhost:#{port}/"
  )()
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
