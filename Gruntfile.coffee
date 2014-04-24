module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-exec'
  grunt.loadNpmTasks 'grunt-jasmine-node'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-pg'

  dbConfig = require './database'

  grunt.initConfig
    exec:
      createdb:
        cmd: (env) ->
          "createdb #{dbConfig[env].database} -O #{dbConfig[env].user} -h #{dbConfig[env].host} -U #{dbConfig[env].user} || echo 'Database #{dbConfig[env].database} already exists.'"

      dropdb:
        cmd: (env) ->
          if env == 'prod'
            console.log 'Cannot drop production database.'
            "exit 1"
          else
            "dropdb #{dbConfig[env].database} -h #{dbConfig[env].host} -U #{dbConfig[env].user} || echo 'Database #{dbConfig[env].database} does not exist.'"

      migrate:
        cmd: (env, cmd) ->
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

  gruntAlias 'db:migrate', 'Migrate Database', 'exec:migrate'

  gruntAlias 'db:drop', 'Drop database', 'exec:dropdb'

  gruntAlias 'db:create', 'Create database', 'exec:createdb'

  grunt.registerTask 'db:reset', 'Reset database', (env) ->
    grunt.task.run "db:drop:#{env}"
    grunt.task.run "db:create:#{env}"
    grunt.task.run "db:migrate:#{env}"

  gruntAlias 'test', 'Test the thing', 'jasmine_node'

  gruntAlias 'serve', 'Serve the site', 'exec:serve'
