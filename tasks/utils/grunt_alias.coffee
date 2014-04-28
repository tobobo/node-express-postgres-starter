module.exports = (grunt) ->
  (name, description, origName, defaultSuffix) ->
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
