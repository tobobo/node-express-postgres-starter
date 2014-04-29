module.exports = (app) ->
  passport = require 'passport'
  cookieParser = require 'cookie-parser'
  bodyParser = require 'body-parser'
  methodOverride = require 'method-override'
  passportBookshelf = require '../strategies/passport_bookshelf'
  expressSession = require 'express-session'
  PgSession = require('connect-pg-simple')
    session: expressSession

  app.use cookieParser()
  app.use bodyParser()
  app.use methodOverride()

  app.use (req, res, next) ->
    originValid = false
    for host in app.config.clients
      if typeof host == 'string' then host = new RegExp(host)
      originValid = host.test req.headers.origin
      if originValid then break
    if originValid
      res.header 'Access-Control-Allow-Origin', req.headers.origin
      res.header 'Access-Control-Allow-Credentials', true
      res.header 'Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, OPTIONS'
      res.header 'Access-Control-Allow-Headers', 'Content-Type'
    next()

  app.use expressSession
    key: app.config.sessionKey
    secret: app.config.sessionSecret
    cookie:
      maxAge: 30*24*60*60*1000
      domain: app.config.cookieDomain
    store: new PgSession
      conString: ((dbC) -> [
        "postgres://",
        dbC.user,
        if dbC.password? then ":" + dbC.password,
        "@",
        dbC.host,
        if dbC.port? then ":" + dbC.port,
        "/",
        dbC.database
      ].join '') app.db.knex.client.connectionSettings

  passportBookshelf app

  app.use passport.initialize()
  app.use passport.session()
