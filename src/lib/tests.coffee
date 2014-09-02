path = require "path"
cp = require "child_process"

pathToMocha = path.resolve "#{__dirname}/../../node_modules/.bin/mocha"

tests = (exit, reporter, cb) ->
	childProcess = cp.spawn pathToMocha, [
		"--recursive"
		"--compilers"
		"coffee:coffee-script/register"
		"--reporter"
		reporter
		"test"
	]

	childProcess.stdout.on "data", (chunk) ->
		process.stdout.write chunk

	childProcess.stderr.on "data", (chunk) ->
		process.stderr.write chunk

	childProcess.once "close", ->
		if exit
			process.exit()
		else
			cb()

module.exports = tests
