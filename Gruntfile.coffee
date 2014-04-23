module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-exec'

  grunt.initConfig
    exec:
      migrate:
        cmd: (env, cmd) ->
          "db-migrate #{cmd} -e #{env}"

  grunt.task.registerTask 'migrate', 'Migrate database.', (env, cmd) ->
    grunt.task.run "exec:migrate:#{env}:#{cmd}"
