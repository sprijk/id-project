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
		log.info "[browserify:compile] Disabled."
		return cb()

	log.debug "[browserify:compile] Entry file: `#{entryFilePath}`."
	log.debug "[browserify:compile] Target directory path: `#{targetDirectoryPath}`."
	log.debug "[browserify:compile] Target filename: `#{targetFilename}`."

	fs.exists entryFilePath, (exists) ->
		unless exists
			log.info "[browserify:compile] Entry file `#{entryFilePath}` not found."
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
				log.debug "[browserify:compile] Compiling `#{file.path}`."
				return

			.pipe gulp.dest targetDirectoryPath
			.on "end", cb

		return

	return
