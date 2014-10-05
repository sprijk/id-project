path = require "path"

gulp    = require "gulp"
gulpTap = require "gulp-tap"
log     = require "id-debug"

options             = idProjectOptions.copy
enabled             = options.enabled
excluded            = options.excluded
sourceDirectoryPath = path.resolve options.sourceDirectoryPath
targetDirectoryPath = path.resolve options.targetDirectoryPath

gulp.task "copy:compile", (cb) ->
	unless enabled is true
		log.info "Skipping copy:compile: Disabled."
		return cb()

	log.debug "[copy:compile] Source directory path: `#{sourceDirectoryPath}`."
	log.debug "[copy:compile] Target directory path: `#{targetDirectoryPath}`."

	sourceGlob = [ "#{sourceDirectoryPath}/**/*" ].concat excluded

	gulp.src sourceGlob
		.pipe gulpTap (file) ->
			log.debug "[copy:compile] Copying `#{file.path}`."
			return

		.pipe gulp.dest targetDirectoryPath
		.on "end", cb

	return
