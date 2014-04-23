db = require './database.json'

module.exports =
  port: Number(process.env.PORT or 9000)
  db: db
  env: process.env.NODE_ENV or 'prod'
