fs   = require "fs"
path = require "path"

browserify    = require "browserify"
gulp          = require "gulp"
gulpTap       = require "gulp-tap"
log           = require "id-debug"
vinylSource   = require "vinyl-source-stream"
{ Transform } = require "stream"

options             = idProjectOptions.browserify
enabled             = options.enabled
entryFilePath       = path.resolve options.entryFilePath
targetDirectoryPath = path.resolve options.targetDirectoryPath
targetFilename      = options.targetFilename

gulp.task "browserify:compile", [ "coffee:compile", "copy:compile" ], (cb) ->
	unless enabled is true
		log.info "Skipping browserify:compile: Disabled."
		return cb()

	fs.exists entryFilePath, (exists) ->
		unless exists
			log.info "Skipping browserify:compile: File `#{entryFilePath}` not found."
			return cb()

		bundler = browserify
			entries: [ entryFilePath ]
			extensions: [ ".js", ".json", ".jade" ]

		bundler.transform "jadeify"
		bundler.transform "debowerify"

		bundle = bundler.bundle debug: true

		bundle.on "error", log.error.bind log

		bundle
			.pipe vinylSource targetFilename
			.pipe gulpTap (file) ->
				log.debug "browserify:compile: Compiling `#{file.path}` into `#{targetDirectoryPath}`."
				return

			.pipe gulp.dest targetDirectoryPath
			.on "end", cb

		return

	return
