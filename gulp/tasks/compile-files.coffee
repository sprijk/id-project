gulp = require 'gulp'

gulp.task 'compile-files', ->
	gulp.src [ 'src/**/*', '!**/*.coffee', '!**/*.less' ]
		.pipe gulp.dest 'build'
