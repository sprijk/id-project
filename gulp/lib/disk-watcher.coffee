gulp = require 'gulp'

module.exports =
	src:  gulp.watch 'src/**/*',  read: false
	test: gulp.watch 'test/**/*', read: false
