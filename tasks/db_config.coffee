path = require 'path'

module.exports = (grunt) ->
  grunt.registerTask 'db:config', 'Write/delete database configuration for migrations', (shouldDelete) ->
    if shouldDelete == 'delete'
      grunt.file.delete(grunt.config('dbConfigPath'))
    else
      dbConfigStr = JSON.stringify grunt.config('appConfig').db
      grunt.file.mkdir path.dirname(grunt.config('dbConfigPath'))
      grunt.file.write grunt.config('dbConfigPath'), dbConfigStr
