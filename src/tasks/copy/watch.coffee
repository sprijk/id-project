fs   = require "fs"

gulp           = require "gulp"
gulpLivereload = require "gulp-livereload"
log            = require "id-debug"

diskWatcher  = require "../../lib/disk-watcher"
{ copy, rm } = require "../../lib/files"

options      = idProjectOptions.copy
enabled      = options.enabled
watchEnabled = idProjectOptions.watch.enabled

reloadPath = (path) ->
	return if path.match /\.jade$/

	gulpLivereload auto: false
		.write
			path: path

gulp.task "copy:watch", [ "copy:compile", "livereload:run" ], (cb) ->
	unless enabled is true and watchEnabled is true
		log.info "Skipping copy:watch: Disabled."
		return cb()

	diskWatcher.src().on "change", (options) ->
		return if options.path.match /\.(coffee|less)/

		switch options.type
			when "changed"
				copy options.path, (error) ->
					log.error error if error

					reloadPath options.path

			when "added"
				copy options.path, (error) ->
					log.error error if error

					reloadPath options.path

			when "deleted"
				rm options.path, (error) ->
					log.error error if error

	return
