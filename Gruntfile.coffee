module.exports = (grunt) ->
  loadGruntConfig = require('./tasks/utils/load_config') grunt
  loadGruntConfig './tasks/options/',
    appConfig: require('./config')
    dbConfigPath: 'tmp/database.json'

  require('load-grunt-tasks') grunt
  grunt.loadTasks 'tasks'

  gruntAlias = require('./tasks/utils/grunt_alias') grunt

  gruntAlias 'db:drop', 'Drop database', 'exec:dropdb'

  gruntAlias 'db:dropuser', 'Delete user', 'exec:dropuser'

  gruntAlias 'db:dropall', 'Drop database and delete user', ['db:drop', 'db:dropuser']

  gruntAlias 'db:create', 'Create database', 'exec:createdb'

  gruntAlias 'db:createuser', 'Create user', 'exec:createuser'

  gruntAlias 'db:createall', 'Create user and database', ['db:createuser', 'db:create']

  gruntAlias 'db:migrate', 'Migrate Database', ['db:config', 'exec:migrate', 'db:config:delete']

  gruntAlias 'db:init', 'Init database', ['db:createuser', 'db:create', 'db:migrate']

  gruntAlias 'db:reset', 'Reset database', ['db:drop', 'db:create', 'db:migrate']

  gruntAlias 'db:resetall', 'Reset database and user', ['db:dropall', 'db:createall', 'db:migrate']

  gruntAlias 'test', 'Test the thing', 'jasmine_node', 'all'

  gruntAlias 'test:reset', 'Reset the test database and test', ['db:reset:test', 'test']

  gruntAlias 'test:watch', 'Test and watch for changes', 'watch:test'

  gruntAlias 'server', 'Serve the site', 'express', 'dev'

  gruntAlias 'dev', 'Game time.', ['watch:dev']
