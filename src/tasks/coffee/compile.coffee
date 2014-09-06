gulp       = require "gulp"
gulpCoffee = require "gulp-coffee"
log        = require "id-debug"

{
	enabled
} = idProjectOptions.coffee

gulp.task "coffee:compile", (cb) ->
	unless enabled is true
		log.info "Skipping coffee:compile: Disabled."
		return cb()

	coffeeCompiler = gulpCoffee bare: true

	coffeeCompiler.on "error", log.error.bind log

	gulp.src "src/**/*.coffee"
		.pipe coffeeCompiler
		.pipe gulp.dest "build"
		.on "end", cb

	return
