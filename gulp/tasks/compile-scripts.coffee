gulp       = require 'gulp'
gulpCoffee = require 'gulp-coffee'
log        = require 'id-debug'

gulp.task 'compile-scripts', ->
	coffeeCompiler = gulpCoffee bare: true

	coffeeCompiler.on 'error', log.error.bind log

	gulp.src 'src/**/*.coffee'
		.pipe coffeeCompiler
		.pipe gulp.dest 'build'
