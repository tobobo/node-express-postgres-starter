moment = require 'moment'
path = require 'path'

module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-exec'
  grunt.loadNpmTasks 'grunt-jasmine-node'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-pg'

  config = require('./config')()

  dbConfigPath = 'tmp/database.json'

  grunt.initConfig
    exec:
      createdb:
        cmd: (env) ->
          unless env?
            env = 'dev'
          "createdb #{config.db[env].database}
            -O #{config.db[env].user} 
            -h #{config.db[env].host} 
            -U #{config.db[env].user} 
          || echo 'Database #{config.db[env].database} already exists.'"

      dropdb:
        cmd: (env) ->
          unless env?
            env = 'dev'
          if env == 'prod'
            grunt.log.error 'Cannot drop production database.'
            "exit 1"
          else
            "dropdb #{config.db[env].database} 
              -h #{config.db[env].host} 
              -U #{config.db[env].user} 
            || echo 'Database #{config.db[env].database} does not exist.'"

      migrate:
        cmd: (env, cmd) ->
          dir = './app/migrations'
          if env == 'create'
            if cmd?
              fileName = "#{moment.utc().format('YYYYMMDDhhmmss')}-#{cmd.replace('_','-')}.coffee"
              grunt.file.write "app/migrations/#{fileName}",
                "dbm = require 'db-migrate'\ntype = dbm.dataType\n\nexports.up = (db, callback) ->\n\n  callback()\n\nexports.down = (db, callback) ->\n\n  callback()\n\n"
              "exit 0"
            else
              grunt.log.error 'Cannot create a migration without a name'
              "exit 1"
          else
            unless env?
              env = 'dev'
            unless cmd?
              cmd = 'up'
            "node_modules/db-migrate/bin/db-migrate #{cmd} -e #{env} -m #{dir} --config \"#{dbConfigPath}\"|| echo 'Migration failed.'"

      serve:
        cmd: (env) ->
          if !env then env = 'dev'
          "NODE_ENV=#{env} node_modules/coffee-script/bin/coffee server.coffee"

    jasmine_node:
      options:
        extensions: 'coffee'
        coffee: true
      all: ['spec']
      controllers: ['spec/controllers']
      models: ['spec/models']
      middlewares: ['spec/middlewares']
      strategies: ['spec/strategies']
      initializers: ['spec/initializers']

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

  gruntAlias = (name, description, origName, defaultSuffix) ->
    grunt.task.registerTask name, description, ->
      args = Array.prototype.slice.call(arguments)

      suffix = if args.length > 0 
        ":" + args.join(':')
      else if defaultSuffix?
        ":#{defaultSuffix}"
      else ""

      if typeof origName == 'object'
        for task in origName
          grunt.task.run (task + suffix)
      else
        grunt.task.run (origName + suffix)

  grunt.registerTask 'db:config', 'Write/delete database configuration for migrations', (shouldDelete) ->
    if shouldDelete == 'delete'
      grunt.file.delete(dbConfigPath)
    else
      dbConfigStr = JSON.stringify config.db
      grunt.file.mkdir path.dirname(dbConfigPath)
      grunt.file.write dbConfigPath, dbConfigStr

  gruntAlias 'db:drop', 'Drop database', 'exec:dropdb'

  gruntAlias 'db:create', 'Create database', 'exec:createdb'

  gruntAlias 'db:migrate', 'Migrate Database', ['db:config', 'exec:migrate', 'db:config:delete']

  gruntAlias 'db:reset', 'Reset database', ['db:drop', 'db:create', 'db:migrate']

  gruntAlias 'test', 'Test the thing', 'jasmine_node', 'all'

  gruntAlias 'test:reset', 'Reset the test database and test', ['db:reset:test', 'test']

  gruntAlias 'serve', 'Serve the site', 'exec:serve'
