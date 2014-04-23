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
          "node_modules/db-migrate/bin/db-migrate #{cmd} -e #{env}"

      serve:
        cmd: (env) ->
          if !env then env = 'dev'
          "NODE_ENV=#{env} node_modules/coffee-script/bin/coffee server.coffee"

    jasmine_node:
      options:
        matchall: true
        extensions: 'coffee'
        coffee: true
      all: ['spec']

    watch:
      options:
        forever: false
      test:
        files: ['spec/**/*', 'app/**/*']
        tasks: ['test']
        
      serve:
        files: ['spec/**/*', 'app/**/*', '*']
        tasks: ['serve:dev']

      dev:
        files: ['spec/**/*',  'app/**/*', '*']
        tasks: ['test', 'serve:dev']

  gruntAlias = (name, description, origName) ->
    grunt.task.registerTask name, description, ->
      args = Array.prototype.slice.call(arguments)
      task = origName
      if args.length > 0 then task += ":" + args.join(':')
      grunt.task.run task

  gruntAlias 'migrate', 'Migrate Database', 'exec:migrate'

  gruntAlias 'test', 'Test the thing', 'jasmine_node'

  gruntAlias 'serve', 'Serve the site', 'exec:serve'
