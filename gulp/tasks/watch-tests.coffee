fs   = require 'fs'
gulp = require 'gulp'
path = require 'path'

diskWatcher = require '../lib/disk-watcher'
tests       = require '../lib/tests'

runTests = ->
	tests false, 'spec', ->

changeHandler = (options) ->
	return unless options.path.match /\.coffee/

	switch options.type
		when 'changed'
			runTests()

		when 'added'
			runTests()

gulp.task 'watch-tests', [ 'compile' ], (cb) ->
	diskWatcher.src.on  'change', changeHandler
	diskWatcher.test.on 'change', changeHandler

	runTests()
