gulp = require 'gulp'
log  = require 'id-debug'

docs = require '../../lib/docs'

options = idProjectOptions

gulp.task 'documentation:compile', (cb) ->
	unless options.documentation is true
		log.info "Skipping documentation:compile: Disabled."
		return cb()

	docs false, cb

	return
