fs   = require "fs"
path = require "path"

gulp           = require "gulp"
gulpTap        = require "gulp-tap"
gulpLivereload = require "gulp-livereload"
log            = require "id-debug"
vinylSource    = require "vinyl-source-stream"
watchify       = require "watchify"

options             = idProjectOptions.browserify
enabled             = options.enabled
entryFilePath       = path.resolve options.entryFilePath
targetDirectoryPath = path.resolve options.targetDirectoryPath
targetFilename      = options.targetFilename
watchEnabled        = idProjectOptions.watch.enabled

gulp.task "browserify:watch", [ "browserify:compile", "livereload:run" ], (cb) ->
	unless enabled is true and watchEnabled is true
		log.info "Skipping browserify:watch: Disabled."
		return cb()

	fs.exists entryFilePath, (exists) ->
		unless exists
			log.info "Skipping browserify:watch: File `#{entryFilePath}` not found."
			return cb()

		bundler = watchify
			entries: [ entryFilePath ]
			extensions: [ ".js", ".json", ".jade" ]

		bundler.transform "jadeify"
		bundler.transform "debowerify"

		compile = ->
			log.debug "browserify:watch: Compiling `#{entryFilePath}`."

			bundle = bundler.bundle debug: true

			bundle.on "error", log.error.bind log

			bundle
				.pipe vinylSource targetFilename

				.pipe gulpTap (file) ->
					log.debug "browserify:compile: Compiling `#{file.path}` into `#{targetDirectoryPath}`."
					return

				.pipe gulp.dest targetDirectoryPath
				.pipe gulpLivereload auto: false

		bundler.on "update", compile

		# Needed for watchify to start watching..
		compile()

		return

	return
