fs = require "fs"
path = require "path"

gulp     = require "gulp"
gulpLess = require "gulp-less"
log      = require "id-debug"

options             = idProjectOptions.less
enabled             = options.enabled
entryFilePath       = path.resolve options.entryFilePath
targetDirectoryPath = path.resolve options.targetDirectoryPath

gulp.task "less:compile", (cb) ->
	unless enabled is true
		log.info "Skipping less:compile: Disabled."
		return cb()

	fs.exists entryFilePath, (exists) ->
		unless exists
			log.info "Skipping less:compile: File `#{entryFilePath}` not found."
			return cb()

		gulp.src entryFilePath
			.pipe gulpLess()
			.pipe gulp.dest targetDirectoryPath
			.on "end", cb

	return
