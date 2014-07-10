cp = require 'child_process'

gulp = require 'gulp'

packageJSON = require "#{__dirname}/../../package.json"

gulp.task 'compile-documentation', (cb) ->
	childProcess = cp.spawn "#{__dirname}/../../node_modules/.bin/codo", [
		'--output'
		'docs'
		'--name'
		packageJSON.name
		'--undocumented'
		'--private'
		'--verbose'
		'src'
	]

	childProcess.stdout.on 'data', (chunk) ->
		process.stdout.write chunk

	childProcess.stderr.on 'data', (chunk) ->
		process.stderr.write chunk

	childProcess.once 'close', cb
