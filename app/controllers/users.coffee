module.exports = (app) ->
  createUser = require('../middlewares/create_user') app

  render = (req, res) ->
    responseObj =
      meta: res.meta
    if res.user.length?
      responseObj.users = res.user.map (user) -> user.toJSON()
    else
      responseObj.user = res.user
      
    res.send responseObj


  app.post '/users', createUser, render
