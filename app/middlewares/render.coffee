module.exports = (app) ->
  (objKey) ->
    (req, res) ->
      responseObj =
        meta: res.meta 
      procObj = (obj) ->
        if obj? and obj.toJSON?
          obj.toJSON()
        else
          obj

      if res.content? and res.content.length?
        responseObj[objKey] = res.content.map procObj
      else
        responseObj[objKey] = procObj res.content
      res.send responseObj
