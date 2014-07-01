async = require 'async'
gulp = require 'gulp'

gulp.task 'compile', [
	'compile-scripts-bundle'
	'compile-documentation'
	'compile-scripts'
	'compile-files'
	'compile-styles'
]
