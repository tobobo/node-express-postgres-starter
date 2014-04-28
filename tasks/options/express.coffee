module.exports = (grunt) ->
  options:
    background: false
    script: 'server.coffee'
    opts: ['node_modules/coffee-script/bin/coffee']
    port: grunt.config('appConfig')(process.env.NODE_ENV or 'dev').port
  dev: ''
  prod:
    options:
      node_env: 'prod'
