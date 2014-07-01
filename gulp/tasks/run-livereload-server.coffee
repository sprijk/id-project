gulp           = require 'gulp'
gulpLivereload = require 'gulp-livereload'

gulp.task 'run-livereload-server', (cb) ->
	gulpLivereload.listen()
	cb()
