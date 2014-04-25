module.exports = (app) ->

  authenticateUser = require('../middlewares/authenticate_user') app
  getCurrentUser = require('../middlewares/get_current_user') app
  render = require('../middlewares/render') app

  app.post '/sessions', authenticateUser, render('session')
  app.get '/sessions', getCurrentUser, render('sessions')
