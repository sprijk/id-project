fs   = require "fs"
path = require "path"
cp   = require "child_process"

log = require "id-debug"

pathToMocha = path.resolve "#{__dirname}/../../node_modules/.bin/mocha"
pathToTestsDirectory = path.resolve "#{__dirname}/../../test"

tests = (exit, reporter, cb) ->
	fs.exists pathToTestsDirectory, (exists) ->
		unless exists
			log.info "Skipping mocha: Directory `#{pathToTestsDirectory}` not found."
			return cb()

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
