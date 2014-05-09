moment = require 'moment'

module.exports = (grunt) ->

  createuser:
    cmd: (env) ->
      unless env?
        env = 'dev'
      dbConfig = grunt.config('appConfig')(env).db
      pgHbaPath = '/usr/local/var/postgres/pg_hba.conf'
      if dbConfig.host != 'localhost'
        grunt.log.error 'Can only create user for local database.'
        "exit 1"
      else
        "createuser #{dbConfig.user} --createdb"

  dropuser:
    cmd: (env) ->
      unless env?
        env = 'dev'
      dbConfig = grunt.config('appConfig')(env).db
      pgHbaPath = '/usr/local/var/postgres/pg_hba.conf'
      if dbConfig.host != 'localhost'
        grunt.log.error 'Can only drop user for local database.'
        "exit 1"
      else
        "dropuser #{dbConfig.user}"

  createdb:
    cmd: (env) ->
      dbConfig = grunt.config('appConfig')(env).db
      unless env?
        env = 'dev'
      "createdb #{dbConfig.database}
        -O #{dbConfig.user}
        -h #{dbConfig.host}
        -U #{dbConfig.user}
      || echo 'Database #{dbConfig.database} already exists.'"

  dropdb:
    cmd: (env) ->
      dbConfig = grunt.config('appConfig')(env).db
      unless env?
        env = 'dev'
      if env == 'prod'
        grunt.log.error 'Cannot drop production database.'
        "exit 1"
      else
        "dropdb #{dbConfig.database}
          -h #{dbConfig.host}
          -U #{dbConfig.user}
        || echo 'Database #{dbConfig.database} does not exist.'"

  migrate:
    cmd: (env, cmd) ->
      dir = './app/migrations/'
      if env == 'create'
        name = cmd
        if name?
          fileName = "#{moment.utc().format('YYYYMMDDhhmmss')}-#{name.replace('_','-')}.coffee"
          grunt.file.write "#{dir}#{fileName}",
            "dbm = require 'db-migrate'\ntype = dbm.dataType\n\nexports.up = (db, callback) ->\n\n  callback()\n\nexports.down = (db, callback) ->\n\n  callback()\n\n"
          grunt.log.writeln "Created migration #{fileName}"
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
