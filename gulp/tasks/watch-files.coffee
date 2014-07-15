fs   = require 'fs'

gulp           = require 'gulp'
gulpLivereload = require 'gulp-livereload'
log            = require 'id-debug'

diskWatcher  = require '../lib/disk-watcher'
{ copy, rm } = require '../lib/files'

reloadPath = (path) ->
	return if path.match /\.jade$/

	gulpLivereload auto: false
		.write
			path: path

gulp.task 'watch-files', [ 'compile-files', 'run-livereload-server' ], (cb) ->
	diskWatcher.src().on 'change', (options) ->
		return if options.path.match /\.(coffee|less)/

		switch options.type
			when 'changed'
				copy options.path, (error) ->
					log.error error if error

					reloadPath options.path

			when 'added'
				copy options.path, (error) ->
					log.error error if error

					reloadPath options.path

			when 'deleted'
				rm options.path, (error) ->
					log.error error if error
