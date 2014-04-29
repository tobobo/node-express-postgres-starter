module.exports = (env) ->
  appName = 'postgres_starter'
  port = process.env.PORT or 8888

  config = 
    env: env
    appName: appName
    port: port
    salt_work_factor: 10
    sessionKey: "#{appName}_session"
    sessionSecret: process.env["#{appName.toUpperCase()}_SESSION_SECRET"] or 'keyboard cat'
    url: "http://localhost:#{port}"
    clients: ["http://localhost:4200"]
    cookieDomain: ''
    db: 
      driver: "pg",
      user: "#{appName}_dev",
      host: "localhost",  
      database: "#{appName}_dev"


  try
    filename = "./environments/#{env}"
    require.resolve filename
    thisEnv = require(filename) config

  catch e
    if !e.code or e.code != 'MODULE_NOT_FOUND'
      console.log e

  if thisEnv? then for k, v of thisEnv
    config[k] = v

  config
