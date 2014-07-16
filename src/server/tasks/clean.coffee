gulp = require 'gulp'
log  = require 'id-debug'

{ cleanBuildDirectory } = require '../lib/clean'

options = idProjectOptions

gulp.task 'clean', (cb) ->
	unless options.clean is true
		log.info "Skipping clean: Disabled."
		return cb()

	cleanBuildDirectory './build', cb

	return
