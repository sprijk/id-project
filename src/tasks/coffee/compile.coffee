gulp       = require "gulp"
gulpCoffee = require "gulp-coffee"
log        = require "id-debug"

{
	enabled
	sourceDirectoryPath
	targetDirectoryPath
} = idProjectOptions.coffee

gulp.task "coffee:compile", (cb) ->
	unless enabled is true
		log.info "Skipping coffee:compile: Disabled."
		return cb()

	coffeeCompiler = gulpCoffee bare: true

	coffeeCompiler.on "error", log.error.bind log

	gulp.src "#{sourceDirectoryPath}/**/*.coffee"
		.pipe coffeeCompiler
		.pipe gulp.dest targetDirectoryPath
		.on "end", cb

	return
