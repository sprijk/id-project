gulp = require "gulp"
log  = require "id-debug"

options = idProjectOptions

gulp.task "copy:compile", (cb) ->
	unless options.copy is true
		log.info "Skipping copy:compile: Disabled."
		return cb()

	gulp.src [ "src/**/*", "!**/*.coffee", "!**/*.less" ]
		.pipe gulp.dest "build"
		.on "end", cb

	return
