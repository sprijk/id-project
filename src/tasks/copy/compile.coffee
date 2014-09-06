gulp = require "gulp"
log  = require "id-debug"

{
	enabled
} = idProjectOptions.copy

gulp.task "copy:compile", (cb) ->
	unless enabled is true
		log.info "Skipping copy:compile: Disabled."
		return cb()

	gulp.src [ "src/**/*", "!**/*.coffee", "!**/*.less" ]
		.pipe gulp.dest "build"
		.on "end", cb

	return
