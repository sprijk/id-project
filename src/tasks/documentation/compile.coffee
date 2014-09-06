gulp = require "gulp"
log  = require "id-debug"

docs = require "../../lib/docs"

options = idProjectOptions.documentation
enabled = options.enabled

gulp.task "documentation:compile", (cb) ->
	unless enabled is true
		log.info "Skipping documentation:compile: Disabled."
		return cb()

	docs false, cb

	return
