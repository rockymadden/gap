module.exports = (grunt) ->
	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'
		coffee:
			core:
				options: join: true
				files: 'build/gap.js': [
					'source/core/coffeescript/func.coffee'
					'source/core/coffeescript/dom.coffee'
					'source/core/coffeescript/tracker/mousedown.coffee'
					'source/core/coffeescript/tracker/scroll.coffee'
					'source/core/coffeescript/tracker/time.coffee'
					'source/core/coffeescript/api.coffee'
					'source/core/coffeescript/core.coffee'
				]
			test: files: [
				'build/func-test.js': 'source/test/coffeescript/func-test.coffee'
				'build/core-test.js': 'source/test/coffeescript/core-test.coffee'
				'build/api-test.js': 'source/test/coffeescript/api-test.coffee'
				'build/tracker/mousedown-test.js': 'source/test/coffeescript/tracker/mousedown-test.coffee'
				'build/tracker/scroll-test.js': 'source/test/coffeescript/tracker/scroll-test.coffee'
				'build/tracker/time-test.js': 'source/test/coffeescript/tracker/time-test.coffee'
			]
		copy: test: files: [
			'build/func-test.html': 'source/test/html/func-test.html'
			'build/core-test.html': 'source/test/html/core-test.html'
			'build/api-test.html': 'source/test/html/api-test.html'
			'build/readme-test.html': 'source/test/html/readme-test.html'
			'build/tracker/mousedown-test.html': 'source/test/html/tracker/mousedown-test.html'
			'build/tracker/scroll-test.html': 'source/test/html/tracker/scroll-test.html'
			'build/tracker/time-test.html': 'source/test/html/tracker/time-test.html'
		]
		uglify: core: files: ['build/gap.min.js': 'build/gap.js']
		qunit: all: ['build/**/*-test.html']

	grunt.loadNpmTasks('grunt-contrib-coffee')
	grunt.loadNpmTasks('grunt-contrib-copy')
	grunt.loadNpmTasks('grunt-contrib-uglify')
	grunt.loadNpmTasks('grunt-contrib-qunit')

	grunt.registerTask('default', ['coffee', 'uglify', 'copy'])
	grunt.registerTask('test', ['default', 'qunit'])
