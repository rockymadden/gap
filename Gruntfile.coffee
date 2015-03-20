module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      main:
        options: join: true
        files: 'bld/gap.js': [
          'src/main/coffeescript/func.coffee'
          'src/main/coffeescript/dom.coffee'
          'src/main/coffeescript/tracker/mousedown.coffee'
          'src/main/coffeescript/tracker/scroll.coffee'
          'src/main/coffeescript/tracker/time.coffee'
          'src/main/coffeescript/api.coffee'
          'src/main/coffeescript/core.coffee'
        ]
      test: files: [
        'bld/func-test.js': 'src/test/coffeescript/func-test.coffee'
        'bld/core-test.js': 'src/test/coffeescript/core-test.coffee'
        'bld/api-test.js': 'src/test/coffeescript/api-test.coffee'
        'bld/tracker/mousedown-test.js': 'src/test/coffeescript/tracker/mousedown-test.coffee'
        'bld/tracker/scroll-test.js': 'src/test/coffeescript/tracker/scroll-test.coffee'
        'bld/tracker/time-test.js': 'src/test/coffeescript/tracker/time-test.coffee'
      ]
    copy:
      main: files: [
        'dst/gap.js': 'bld/gap.js'
        'dst/gap.min.js': 'bld/gap.min.js'
      ]
      test: files: [
        'bld/func-test.html': 'src/test/html/func-test.html'
        'bld/core-test.html': 'src/test/html/core-test.html'
        'bld/api-test.html': 'src/test/html/api-test.html'
        'bld/readme-test.html': 'src/test/html/readme-test.html'
        'bld/tracker/mousedown-test.html': 'src/test/html/tracker/mousedown-test.html'
        'bld/tracker/scroll-test.html': 'src/test/html/tracker/scroll-test.html'
        'bld/tracker/time-test.html': 'src/test/html/tracker/time-test.html'
      ]
    uglify: main: files: ['bld/gap.min.js': 'bld/gap.js']
    qunit: all: ['bld/**/*-test.html']

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-qunit')

  grunt.registerTask('build', ['coffee', 'uglify', 'copy'])
  grunt.registerTask('default', ['build'])
  grunt.registerTask('test', ['build', 'qunit'])
