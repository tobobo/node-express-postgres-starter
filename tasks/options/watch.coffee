module.exports =
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
