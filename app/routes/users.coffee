module.exports = (app) ->
  createUser = require('../middlewares/create_user') app
  render = require('../middlewares/render') app

  app.post '/users', createUser, render('user')
