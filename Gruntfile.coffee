module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-exec'

  grunt.initConfig
    exec:
      migrate:
        cmd: (env, cmd) ->
          "db-migrate #{cmd} -e #{env}"
      rename:
        cmd: (name) ->
          package = require 'package.json'
          "find . -type f -print0 | xargs -0 sed -i 's/#{package.name}/#{name}/g' && find . -type f -print0 | xargs -0 sed -i 's/#{package.name.toUpperCase()}/#{name.toUpperCase()}/g'"

  grunt.task.registerTask 'migrate', 'Migrate database.', (env, cmd) ->
    grunt.task.run "exec:migrate:#{env}:#{cmd}"

  grunt.task.registerTask 'rename', 'Rename app.', (name) ->
    grunt.task.run "exec:rename:#{env}:#{cmd}"
