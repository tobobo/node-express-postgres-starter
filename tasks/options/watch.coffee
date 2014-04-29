module.exports =
  options:
    interrupt: true

  test:
    files: ['spec/**/*', 'app/**/*', '*']
    tasks: ['test']
    
  serve:
    files: ['app/**/*', '*']
    tasks: ['serve']

  dev:
    files: ['spec/**/*',  'app/**/*', '*']
    tasks: ['test', 'serve']
