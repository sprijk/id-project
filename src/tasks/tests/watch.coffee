fs   = require 'fs'
path = require 'path'

gulp = require 'gulp'
log  = require 'id-debug'

diskWatcher = require '../../lib/disk-watcher'
tests       = require '../../lib/tests'

options = idProjectOptions

runTests = ->
	tests false, 'progress', ->

changeHandler = (options) ->
	return unless options.path.match /\.coffee/

	switch options.type
		when 'changed'
			runTests()

		when 'added'
			runTests()

gulp.task 'tests:watch', [ 'compile' ], (cb) ->
	unless options.tests is true and options.watch is true
		log.info "Skipping tests:watch: Disabled."
		return cb()


	diskWatcher.src().on  'change', changeHandler
	diskWatcher.test().on 'change', changeHandler

	runTests()

	return
