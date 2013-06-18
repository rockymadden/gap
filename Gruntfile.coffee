module.exports = (grunt) ->
	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'
		coffee:
			release:
				options: join: true
				files: 'gap.js': [
					'src/util.coffee',
					'src/tracker/mousedown.coffee',
					'src/tracker/scroll.coffee',
					'src/tracker/time.coffee',
					'src/gap.coffee',
					'src/core.coffee'
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
