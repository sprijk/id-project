fs = require "fs"

gulp     = require "gulp"
gulpLess = require "gulp-less"
log      = require "id-debug"

options             = idProjectOptions
entryFilePath       = options.lessEntryFilePath
targetDirectoryPath = options.lessTargetDirectoryPath

gulp.task "less:compile", (cb) ->
	unless options.less is true
		log.info "Skipping less:compile: Disabled."
		return cb()

	fs.exists entryFilePath, (exists) ->
		unless exists
			log.info "Skipping less:compile: File `#{entryFilePath}` not found."
			return cb()

		gulp.src entryFilePath
			.pipe gulpLess()
			.pipe gulp.dest lessTargetDirectoryPath
			.on "end", cb

	return
