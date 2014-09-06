fs = require "fs"

browserify    = require "browserify"
gulp          = require "gulp"
log           = require "id-debug"
vinylSource   = require "vinyl-source-stream"
{ Transform } = require "stream"

{
	enabled
	entryFilePath
	targetFilename
	targetDirectoryPath
} = idProjectOptions.browserify

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
			.pipe gulp.dest targetDirectoryPath
			.on "end", cb

		return

	return
