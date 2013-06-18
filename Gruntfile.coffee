module.exports = (grunt) ->
	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'
		coffee:
			release:
				options: join: true
				files: 'gap.js': [
					'source/util.coffee',
					'source/tracker/mousedown.coffee',
					'source/tracker/scroll.coffee',
					'source/tracker/time.coffee',
					'source/gap.coffee',
					'source/core.coffee'
				]
			tests: files:
				'test/core.test.js': 'test/core.test.coffee',
				'test/gap.test.js': 'test/gap.test.coffee',
				'test/tracker/mousedown.test.js': 'test/tracker/mousedown.test.coffee',
				'test/tracker/scroll.test.js': 'test/tracker/scroll.test.coffee',
				'test/tracker/time.test.js': 'test/tracker/time.test.coffee'
		uglify: release: files: 'gap.min.js': 'gap.js'
		qunit: all: ['test/*.html', 'test/tracker/*.html']

	grunt.loadNpmTasks('grunt-contrib-coffee')
	grunt.loadNpmTasks('grunt-contrib-uglify')
	grunt.loadNpmTasks('grunt-contrib-qunit')

	grunt.registerTask('default', ['coffee', 'uglify'])
	grunt.registerTask('test', ['qunit', 'coffee', 'uglify'])
