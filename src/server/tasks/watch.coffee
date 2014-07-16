gulp = require 'gulp'

gulp.task 'watch', [
	'copy:watch'
	'coffee:watch'
	'browserify:watch'
	'nodemon:run'
	'less:watch'
	'tests:watch'
]
