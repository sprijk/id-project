fs   = require 'fs'
path = require 'path'

gulp           = require 'gulp'
gulpLess       = require 'gulp-less'
gulpLivereload = require 'gulp-livereload'
log            = require 'id-debug'

diskWatcher = require '../lib/disk-watcher'

gulp.task 'watch-styles', [ 'compile-styles', 'run-livereload-server' ], (cb) ->
	compilePath = (sourcePath) ->
		sourceDirectory = path.dirname sourcePath
		buildDirectory  = sourceDirectory
			.replace 'src', 'build'
			.replace '.less', '.css'
			.replace '/less', '/css'

		gulp.src sourcePath
			.pipe gulpLess()
			.pipe gulp.dest buildDirectory
			.pipe gulpLivereload auto: false

	removePath = (sourcePath) ->
		targetPath = sourcePath
			.replace 'src',   'build'
			.replace '.less', '.css'
			.replace '/less', '/css'

		fs.unlink targetPath, (error) ->
			log.error error if error

	diskWatcher.src.on 'change', (options) ->
		return unless options.path.match /\.less/

		switch options.type
			when 'changed'
				compilePath './src/client/less/app.less'

			when 'added'
				compilePath './src/client/less/app.less'

			when 'deleted'
				removePath options.path
