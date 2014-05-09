module.exports = (app) ->
  (string) ->
    originValid = false
    if string?
      for host in app.config.clients
        if typeof host == 'string' then host = new RegExp(host)
        originValid = host.test string
        if originValid then break
    originValid
