fs = require "fs"

gulp     = require "gulp"
gulpLess = require "gulp-less"
log      = require "id-debug"

{
	enabled
	entryFilePath
	targetDirectoryPath
} = idProjectOptions.less

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
