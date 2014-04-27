module.exports = (app) ->

  (req, res, next) ->
    req.logOut()
    res.meta = 'You have been logged out.'
    next()
