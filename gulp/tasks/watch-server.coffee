fs   = require 'fs'
path = require 'path'

gulp        = require 'gulp'
gulpNodemon = require 'gulp-nodemon'

watchNodemon = ->
	monitor = gulpNodemon
		#verbose: true
		script: 'app.js'
		watch:  [ 'build/server/**/*.js' ]

gulp.task 'watch-server', [ 'compile' ], (cb) ->
	watchNodemon()
	cb()
