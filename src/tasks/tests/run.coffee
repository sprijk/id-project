gulp = require "gulp"
log  = require "id-debug"

tests = require "../../lib/tests"

options = idProjectOptions

{
	enabled
	directoryPath
} = idProjectOptions.less

gulp.task "tests:run", [ "compile" ], (cb) ->
	unless enabled is true
		log.info "Skipping tests:run: Disabled."
		return cb()

	tests directoryPath, true, "spec", cb

	return
