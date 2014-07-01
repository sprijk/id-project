cp = require 'child_process'

tests = (exit, reporter, cb) ->
	childProcess = cp.spawn 'mocha', [
		'--recursive'
		'--compilers'
		'coffee:coffee-script/register'
		'--reporter'
		reporter
		'test'
	]

	childProcess.stdout.on 'data', (chunk) ->
		process.stdout.write chunk

	childProcess.stderr.on 'data', (chunk) ->
		process.stderr.write chunk

	if exit
		childProcess.once 'close', ->
			process.exit()
	else
		cb()

module.exports =
	tests: tests
