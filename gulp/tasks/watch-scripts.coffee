fs   = require 'fs'
path = require 'path'

gulp           = require 'gulp'
gulpCoffee     = require 'gulp-coffee'
gulpLivereload = require 'gulp-livereload'
log            = require 'id-debug'

diskWatcher = require '../lib/disk-watcher'

gulp.task 'watch-scripts', [ 'compile-scripts', 'run-livereload-server' ], (cb) ->
	compilePath = (sourcePath) ->
		coffeeCompiler = gulpCoffee bare: true

		coffeeCompiler.on 'error', log.error.bind log

		sourceDirectory = path.dirname sourcePath
		buildDirectory  = sourceDirectory.replace 'src', 'build'

		gulp.src sourcePath
			.pipe coffeeCompiler
			.pipe gulp.dest buildDirectory

	removePath = (sourcePath) ->
		targetPath = sourcePath
			.replace 'src',     'build'
			.replace '.coffee', '.js'

		fs.unlink targetPath, (error) ->
			log.error error if error

	diskWatcher.src.on 'change', (options) ->
		return unless options.path.match /\.coffee$/

		switch options.type
			when 'changed'
				compilePath options.path

			when 'added'
				compilePath options.path

			when 'deleted'
				removePath options.path
