gulp = require 'gulp'

tests = require '../lib/tests'

gulp.task 'run-tests', [ 'compile' ], (cb) ->
	tests true, 'spec', cb
