module.exports = (app) ->
  authenticateUser = require('../middlewares/authenticate_user') app
  authenticateService = require('../middlewares/authenticate_service') app
  getCurrentUser = require('../middlewares/get_current_user') app
  logOut = require('../middlewares/log_out') app
  render = require('../middlewares/render') app

  app.post '/auth', authenticateUser, render('session')
  app.get '/auth', getCurrentUser, render('sessions')
  app.delete '/auth', logOut, render('session')

  app.get '/auth/facebook', authenticateService('facebook').auth
  app.get '/auth/facebook/callback', authenticateService('facebook').callback
