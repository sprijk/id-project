gulp       = require 'gulp'
gulpCoffee = require 'gulp-coffee'

gulp.task 'compile-scripts', ->
	coffeeCompiler = gulpCoffee bare: true

	coffeeCompiler.on 'error', (error) ->
		console.log error

	gulp.src 'src/**/*.coffee'
		.pipe coffeeCompiler
		.pipe gulp.dest 'build'
