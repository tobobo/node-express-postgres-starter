S = require 'string'

module.exports = (app) ->

  filterKeys = (attrs, fn, options) ->
    shouldDelete = not (options? and options.keep)
    for k, v of attrs
      if shouldDelete then delete attrs[k]
      attrs[fn(k)] = v
    attrs

  app.db.Model.extend

    format: (attrs, options) ->
      filterKeys attrs, ((k) -> S(k).underscore().s), options

    parse: (attrs, options) ->
      filterKeys attrs, ((k) -> S(k).camelize().s), options

    set: ->
      result = app.db.Model.prototype.set.apply @, arguments
      @attributes = @format @attributes,
        keep: true
      return result
