fs = require('fs')
print = require('sys').print
spawn = require('child_process').spawn

build = (callback) ->
	coffee = spawn 'coffee', ['-c', '-o', '.', 'src']

	coffee.stderr.on 'data', (data) -> process.stderr.write data.toString()
	coffee.stdout.on 'data', (data) -> print data.toString()
	coffee.on 'exit', (code) -> callback?() if code is 0

task 'build', 'Build gap.js.', -> build()
