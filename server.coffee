config = require('./config')(process.env.NODE_ENV or 'dev')
app = require('./app/init') config

app.listen config.port
