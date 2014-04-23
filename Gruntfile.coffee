module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-exec'
  grunt.loadNpmTasks 'grunt-jasmine-node'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.initConfig
    exec:
      migrate:
        cmd: (env, cmd) ->
          unless cmd?
            cmd = env
            env = 'dev'
          unless cmd?
            cmd = 'up'
          "db-migrate #{cmd} -e #{env}"

    jasmine_node:
      options:
        matchall: true
        extensions: 'coffee'
        coffee: true
      all: ['spec']

    watch:
      all:
        files: ['spec/**/*', 'app/**/*'],
        tasks: ['test']

  gruntAlias = (name, description, origName) ->
    grunt.task.registerTask name, description, ->
      args = Array.prototype.slice.call(arguments)
      task = origName
      if args.length > 0 then task += ":" + args.join(':')
      grunt.task.run task

  gruntAlias 'migrate', 'Migrate Database', 'exec:migrate'

  gruntAlias 'test', 'Test the thing', 'jasmine_node'
