config = require('./config') process.env.NODE_ENV or 'dev'
app = require('./app/app') config

app.listen config.port
