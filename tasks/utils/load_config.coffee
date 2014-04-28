module.exports = (grunt) ->
  (configPath, config) ->
    glob = require("glob")
    path = require("path")
    grunt.initConfig config
    
    object = {}
    glob.sync("*",
      cwd: configPath
    ).forEach (option) ->
      key = option.replace(/\.coffee$/, "")
      optFile = require('./' + path.relative(__dirname, configPath + option))
      object[key] = if typeof optFile == 'function'
        optFile grunt
      else
        optFile

    grunt.initConfig grunt.util._.extend config, object
