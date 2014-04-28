module.exports = (config) ->
  url: "http://#{config.appName}_server.herokuapp.com"
  db: process.env["#{config.appName.toUpperCase()}_DB_URL"]
