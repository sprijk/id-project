fs   = require "fs"
path = require "path"

gulp           = require "gulp"
gulpLess       = require "gulp-less"
gulpLivereload = require "gulp-livereload"
log            = require "id-debug"

diskWatcher = require "../../lib/disk-watcher"

options             = idProjectOptions
entryFilePath       = options.lessEntryFilePath
targetDirectoryPath = options.lessTargetDirectoryPath

gulp.task "less:watch", [ "less:compile", "livereload:run" ], (cb) ->
	unless options.less is true and options.watch is true
		log.info "Skipping less:watch: Disabled."
		return cb()

	fs.exists entryFilePath, (exists) ->
		unless exists
			log.info "Skipping less:compile: File `#{entryFilePath}` not found."
			return cb()

		compilePath = (sourcePath) ->
			sourceDirectory = path.dirname sourcePath

			gulp.src sourcePath
				.pipe gulpLess()
				.pipe gulp.dest targetDirectoryPath
				.pipe gulpLivereload auto: false

		removePath = (sourcePath) ->
			targetPath = sourcePath
				.replace "src",   "build"
				.replace ".less", ".css"
				.replace "/less", "/css"

			fs.unlink targetPath, (error) ->
				log.error error if error

		diskWatcher.src().on "change", (options) ->
			return unless options.path.match /\.less/

			switch options.type
				when "changed"
					compilePath entryFilePath

				when "added"
					compilePath entryFilePath

				when "deleted"
					removePath options.path

	return
