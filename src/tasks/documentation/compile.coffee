gulp = require "gulp"
log  = require "id-debug"

docs = require "../../lib/docs"

{
	enabled
} = idProjectOptions.documentation

gulp.task "documentation:compile", (cb) ->
	unless enabled is true
		log.info "Skipping documentation:compile: Disabled."
		return cb()

	docs false, cb

	return
