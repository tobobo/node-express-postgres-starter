module.exports = (config) ->
  db:
    driver: "pg",
    user: "#{config.appName}_test",
    host: "localhost",
    database: "#{config.appName}_test"
  cookieDomain: ''
