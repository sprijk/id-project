fs   = require 'fs'
path = require 'path'

gulp           = require 'gulp'
gulpCoffee     = require 'gulp-coffee'
gulpLivereload = require 'gulp-livereload'

diskWatchServer = require '../lib/disk-watcher-server'

gulp.task 'watch-scripts', [ 'compile-scripts', 'run-disk-watcher-server', 'run-livereload-server' ], (cb) ->
	compilePath = (sourcePath) ->
		coffeeCompiler = gulpCoffee bare: true

		coffeeCompiler.on 'error', (error) ->
			console.log error

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
			console.log error if error

	watchClient = diskWatchServer.connect 'disk-watcher-server', (options) ->
		return unless options.path.match /\.coffee$/

		switch options.type
			when 'changed'
				compilePath options.path

			when 'added'
				compilePath options.path

			when 'deleted'
				removePath options.path
