gulp = require "gulp"
log  = require "id-debug"
path = require "path"

tests = require "../../lib/tests"

options       = idProjectOptions.tests
enabled       = options.enabled
directoryPath = path.resolve options.directoryPath

gulp.task "tests:run", [ "compile" ], (cb) ->
	unless enabled is true
		log.info "Skipping tests:run: Disabled."
		return cb()

	log.debug "[tests:run] Directory path: `#{directoryPath}`."

	tests directoryPath, true, "spec", cb

	return
