module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      main:
        options: join: true
        files: 'bld/gap.js': [
          'src/func.coffee'
          'src/dom.coffee'
          'src/tracker/mousedown.coffee'
          'src/tracker/scroll.coffee'
          'src/tracker/time.coffee'
          'src/api.coffee'
          'src/core.coffee'
        ]
      test: files: [
        'bld/func-test.js': 'test/func-test.coffee'
        'bld/core-test.js': 'test/core-test.coffee'
        'bld/api-test.js': 'test/api-test.coffee'
        'bld/tracker/mousedown-test.js': 'test/tracker/mousedown-test.coffee'
        'bld/tracker/scroll-test.js': 'test/tracker/scroll-test.coffee'
        'bld/tracker/time-test.js': 'test/tracker/time-test.coffee'
      ]
    copy:
      main: files: [
        'dst/gap.js': 'bld/gap.js'
        'dst/gap.min.js': 'bld/gap.min.js'
      ]
      test: files: [
        'bld/func-test.html': 'test/func-test.html'
        'bld/core-test.html': 'test/core-test.html'
        'bld/api-test.html': 'test/api-test.html'
        'bld/readme-test.html': 'test/readme-test.html'
        'bld/tracker/mousedown-test.html': 'test/tracker/mousedown-test.html'
        'bld/tracker/scroll-test.html': 'test/tracker/scroll-test.html'
        'bld/tracker/time-test.html': 'test/tracker/time-test.html'
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
