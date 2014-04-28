path = require 'path'

module.exports = (grunt) ->
  grunt.registerTask 'db:config', 'Write/delete database configuration for migrations', (env) ->
    if env == 'delete'
      grunt.file.delete(grunt.config('dbConfigPath'))
    else
      dbConfigObj = {}
      dbConfigObj[env] = grunt.config('appConfig')(env).db
      dbConfigStr = JSON.stringify dbConfigObj
      grunt.file.mkdir path.dirname(grunt.config('dbConfigPath'))
      grunt.file.write grunt.config('dbConfigPath'), dbConfigStr
