fs   = require 'fs'

gulp           = require 'gulp'
gulpCoffee     = require 'gulp-coffee'
gulpLivereload = require 'gulp-livereload'

diskWatchServer = require '../lib/disk-watcher-server'
{ copy, rm }    = require '../lib/files'

logError = (error) ->
	console.log 'watch-files:', error.stack or error.message or error

reloadPath = (path) ->
	return if path.match /\.jade$/

	gulpLivereload auto: false
		.write
			path: path

gulp.task 'watch-files', [ 'compile-files', 'run-disk-watcher-server', 'run-livereload-server' ], (cb) ->
	watchClient = diskWatchServer.connect 'disk-watcher-server', (options) ->
		return if options.path.match /\.(coffee|less)/

		switch options.type
			when 'changed'
				copy options.path, (error) ->
					logError if error

					reloadPath options.path

			when 'added'
				copy options.path, (error) ->
					logError if error

					reloadPath options.path

			when 'deleted'
				rm options.path, (error) ->
					logError if error
