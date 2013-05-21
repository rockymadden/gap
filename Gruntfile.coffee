module.exports = (grunt) ->
	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'
		coffee: 
			release: 
				files: 'gap.js': 'src/gap.coffee'
			tests: 
				files: 'test/gap.test.js': 'test/gap.test.coffee'
		qunit: 
			all: ['test/*.html']

	grunt.loadNpmTasks 'grunt-contrib-qunit'
	grunt.loadNpmTasks 'grunt-contrib-coffee'

	grunt.registerTask 'default', ['coffee']
	grunt.registerTask 'test', ['qunit', 'coffee']
