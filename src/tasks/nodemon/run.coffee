fs   = require "fs"
path = require "path"

gulp        = require "gulp"
gulpNodemon = require "gulp-nodemon"
log         = require "id-debug"

options       = idProjectOptions
entryFilePath = options.nodemonEntryFilePath
watchGlob     = options.watchGlob

watchNodemon = ->
	monitor = gulpNodemon
		#verbose: true
		script: entryFilePath
		watch:  watchGlob

gulp.task "nodemon:run", [ "compile" ], (cb) ->
	unless options.nodemon is true
		log.info "Skipping nodemon:run: Disabled."
		return cb()

	watchNodemon()
	cb()

	return
