gulp = require 'gulp'

{ cleanBuildDirectory } = require '../lib/clean'

gulp.task 'clean', (cb) ->
	cleanBuildDirectory './build', cb
