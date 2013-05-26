module.exports = (grunt) ->
	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'
		coffee: 
			release: 
				files: 'gap.js': 'src/gap.coffee'
			tests: 
				files: 
					'test/gap.test.js': 'test/gap.test.coffee',
					'test/gaptimetracker.test.js': 'test/gaptimetracker.test.coffee'
		uglify:
			release:
				files: 'gap.min.js': 'gap.js'
		qunit: 
			all: ['test/*.html']

	grunt.loadNpmTasks('grunt-contrib-coffee')
	grunt.loadNpmTasks('grunt-contrib-uglify')
	grunt.loadNpmTasks('grunt-contrib-qunit')

	grunt.registerTask('default', ['coffee', 'uglify'])
	grunt.registerTask('test', ['qunit', 'coffee', 'uglify'])
