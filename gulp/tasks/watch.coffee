gulp = require 'gulp'

gulp.task 'watch', [
	'watch-files'
	'watch-scripts'
	'watch-scripts-bundle'
	'watch-server'
	'watch-styles'
	'watch-tests'
]
