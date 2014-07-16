gulp = require 'gulp'
log  = require 'id-debug'

tests = require '../../lib/tests'

options = idProjectOptions

gulp.task 'tests:run', [ 'compile' ], (cb) ->
	unless options.tests is true
		log.info "Skipping tests:run: Disabled."
		return cb()

	tests true, 'spec', cb

	return
