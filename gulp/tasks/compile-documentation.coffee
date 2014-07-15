gulp = require 'gulp'

docs = require '../lib/docs'

gulp.task 'compile-documentation', (cb) ->
	docs false, cb
