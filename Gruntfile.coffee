module.exports = (grunt) ->
	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'
		coffee:
			release:
				options: join: true
				files: 'build/gap.js': [
					'source/util.coffee',
					'source/tracker/mousedown.coffee',
					'source/tracker/scroll.coffee',
					'source/tracker/time.coffee',
					'source/gap.coffee',
					'source/core.coffee'
				]
			test: files: [
				'build/core-test.js': 'test/core-test.coffee',
				'build/gap-test.js': 'test/gap-test.coffee',
				'build/tracker/mousedown-test.js': 'test/tracker/mousedown-test.coffee',
				'build/tracker/scroll-test.js': 'test/tracker/scroll-test.coffee',
				'build/tracker/time-test.js': 'test/tracker/time-test.coffee'
			]
		copy:
			release: files: [
				'gap.js': 'build/gap.js',
				'gap.min.js': 'build/gap.min.js'
			]
			test: files: [
				'build/core-test.html': 'test/core-test.html',
				'build/gap-test.html': 'test/gap-test.html',
				'build/readme-test.html': 'test/readme-test.html',
				'build/tracker/mousedown-test.html': 'test/tracker/mousedown-test.html',
				'build/tracker/scroll-test.html': 'test/tracker/scroll-test.html',
				'build/tracker/time-test.html': 'test/tracker/time-test.html'
			]
		uglify: release: files: ['build/gap.min.js': 'build/gap.js']
		qunit: all: ['build/**/*-test.html']

	grunt.loadNpmTasks('grunt-contrib-coffee')
	grunt.loadNpmTasks('grunt-contrib-copy')
	grunt.loadNpmTasks('grunt-contrib-uglify')
	grunt.loadNpmTasks('grunt-contrib-qunit')

	grunt.registerTask('default', ['coffee', 'uglify', 'copy'])
	grunt.registerTask('test', ['coffee', 'uglify', 'copy', 'qunit'])
