module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-exec'
  grunt.loadNpmTasks 'grunt-jasmine-node'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-pg'

  config = require('./config')()

  grunt.initConfig
    exec:
      createdb:
        cmd: (env) ->
          "createdb #{config.db[env].database}
            -O #{config.db[env].user} 
            -h #{config.db[env].host} 
            -U #{config.db[env].user} 
          || echo 'Database #{config.db[env].database} already exists.'"

      dropdb:
        cmd: (env) ->
          if env == 'prod'
            console.log 'Cannot drop production database.'
            "exit 1"
          else
            "dropdb #{config.db[env].database} 
              -h #{config.db[env].host} 
              -U #{config.db[env].user} 
            || echo 'Database #{config.db[env].database} does not exist.'"

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
      suffix = if args.length > 0 then ":" + args.join(':') else ""
      if typeof origName == 'object'
        for task in origName
          grunt.task.run (task + suffix)
      else
        grunt.task.run (origName + suffix)

  grunt.registerTask 'db:config', 'Write database configuration', ->
    dbConfigStr = JSON.stringify config.db, null, '  '
    grunt.file.write('./database.json', dbConfigStr + '\n')

  gruntAlias 'db:drop', 'Drop database', 'exec:dropdb'

  gruntAlias 'db:create', 'Create database', 'exec:createdb'

  gruntAlias 'db:migrate', 'Migrate Database', ['db:config', 'exec:migrate']

  gruntAlias 'db:reset', 'Reset database', ['db:drop', 'db:create', 'db:migrate']

  gruntAlias 'test', 'Test the thing', 'jasmine_node'

  gruntAlias 'test:reset', 'Reset the test database and test', ['db:reset:test', 'test']

  gruntAlias 'serve', 'Serve the site', 'exec:serve'
