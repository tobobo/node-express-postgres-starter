config = require './config'
app = require('./app/init') config

app.listen config.port
