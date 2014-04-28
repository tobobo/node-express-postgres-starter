module.exports = (grunt) ->
  createdb:
    cmd: (env) ->
      unless env?
        env = 'dev'
      "createdb #{grunt.config('appConfig').db[env].database}
        -O #{grunt.config('appConfig').db[env].user} 
        -h #{grunt.config('appConfig').db[env].host} 
        -U #{grunt.config('appConfig').db[env].user} 
      || echo 'Database #{grunt.config('appConfig').db[env].database} already exists.'"

  dropdb:
    cmd: (env) ->
      unless env?
        env = 'dev'
      if env == 'prod'
        grunt.log.error 'Cannot drop production database.'
        "exit 1"
      else
        "dropdb #{grunt.config('appConfig').db[env].database} 
          -h #{grunt.config('appConfig').db[env].host} 
          -U #{grunt.config('appConfig').db[env].user} 
        || echo 'Database #{grunt.config('appConfig').db[env].database} does not exist.'"

  migrate:
    cmd: (env, cmd) ->
      dir = './app/migrations'
      if env == 'create'
        name = cmd
        if name?
          fileName = "#{moment.utc().format('YYYYMMDDhhmmss')}-#{name.replace('_','-')}.coffee"
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
        "node_modules/db-migrate/bin/db-migrate #{cmd} -e #{env} -m #{dir} --config \"#{grunt.config('dbConfigPath')}\"|| echo 'Migration failed.'"

  serve:
    cmd: (env) ->
      if !env then env = 'dev'
      "NODE_ENV=#{env} node_modules/coffee-script/bin/coffee server.coffee"
