gulp     = require 'gulp'
gulpLess = require 'gulp-less'

gulp.task 'compile-styles', ->
	gulp.src 'src/client/less/app.less'
		.pipe gulpLess()
		.pipe gulp.dest 'build/client/css'
