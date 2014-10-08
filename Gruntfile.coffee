module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      main:
        options: join: true
        files: 'build/gap.js': [
          'src/main/coffeescript/func.coffee'
          'src/main/coffeescript/dom.coffee'
          'src/main/coffeescript/tracker/mousedown.coffee'
          'src/main/coffeescript/tracker/scroll.coffee'
          'src/main/coffeescript/tracker/time.coffee'
          'src/main/coffeescript/api.coffee'
          'src/main/coffeescript/core.coffee'
        ]
      test: files: [
        'build/func-test.js': 'src/test/coffeescript/func-test.coffee'
        'build/core-test.js': 'src/test/coffeescript/core-test.coffee'
        'build/api-test.js': 'src/test/coffeescript/api-test.coffee'
        'build/tracker/mousedown-test.js': 'src/test/coffeescript/tracker/mousedown-test.coffee'
        'build/tracker/scroll-test.js': 'src/test/coffeescript/tracker/scroll-test.coffee'
        'build/tracker/time-test.js': 'src/test/coffeescript/tracker/time-test.coffee'
      ]
    copy:
      main: files: [
        'dist/gap.js': 'build/gap.js'
        'dist/gap.min.js': 'build/gap.min.js'
      ]
      test: files: [
        'build/func-test.html': 'src/test/html/func-test.html'
        'build/core-test.html': 'src/test/html/core-test.html'
        'build/api-test.html': 'src/test/html/api-test.html'
        'build/readme-test.html': 'src/test/html/readme-test.html'
        'build/tracker/mousedown-test.html': 'src/test/html/tracker/mousedown-test.html'
        'build/tracker/scroll-test.html': 'src/test/html/tracker/scroll-test.html'
        'build/tracker/time-test.html': 'src/test/html/tracker/time-test.html'
      ]
    uglify: main: files: ['build/gap.min.js': 'build/gap.js']
    qunit: all: ['build/**/*-test.html']

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-qunit')

  grunt.registerTask('build', ['coffee', 'uglify', 'copy'])
  grunt.registerTask('default', ['build'])
  grunt.registerTask('test', ['build', 'qunit'])
