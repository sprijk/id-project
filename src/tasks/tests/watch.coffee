fs   = require "fs"
path = require "path"

gulp = require "gulp"
log  = require "id-debug"

diskWatcher = require "../../lib/disk-watcher"
tests       = require "../../lib/tests"

{
	enabled
	directoryPath
} = idProjectOptions.tests

watchEnabled = idProjectOptions.watch.enabled

runTests = ->
	tests directoryPath, false, "progress", ->

changeHandler = (options) ->
	return unless options.path.match /\.coffee/

	# Run tests all cases (changed, added, deleted).
	runTests()

gulp.task "tests:watch", [ "compile" ], (cb) ->
	unless enabled is true and watchEnabled is true
		log.info "Skipping tests:watch: Disabled."
		return cb()

	diskWatcher.src().on  "change", changeHandler
	diskWatcher.test().on "change", changeHandler

	runTests()

	return
