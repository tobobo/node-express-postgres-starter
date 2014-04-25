module.exports = (app) ->
  (req, res, next) ->
    if req.user?
      res.content = [
        user: req.user
      ]
    next()
