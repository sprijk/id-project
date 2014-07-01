gulp = require 'gulp'

{ tests } = require '../lib/run'

gulp.task 'run-tests', [ 'compile' ], (cb) ->
	tests true, 'spec', cb
