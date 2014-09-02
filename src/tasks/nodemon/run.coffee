fs   = require "fs"
path = require "path"

gulp        = require "gulp"
gulpNodemon = require "gulp-nodemon"
log         = require "id-debug"

options = idProjectOptions

watchNodemon = ->
	monitor = gulpNodemon
		#verbose: true
		script: "app.js"
		watch:  [ "build/server/**/*.js" ]

gulp.task "nodemon:run", [ "compile" ], (cb) ->
	unless options.nodemon is true
		log.info "Skipping nodemon:run: Disabled."
		return cb()

	watchNodemon()
	cb()

	return
