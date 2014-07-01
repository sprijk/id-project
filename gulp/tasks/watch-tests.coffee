fs   = require 'fs'
path = require 'path'

gulp           = require 'gulp'
gulpCoffee     = require 'gulp-coffee'
gulpLivereload = require 'gulp-livereload'

{ tests }       = require '../lib/run'
diskWatchServer = require '../lib/disk-watcher-server'

runTests = ->
	tests false, 'list', ->

gulp.task 'watch-tests', [ 'compile', 'run-disk-watcher-server' ], (cb) ->
	watchClient = diskWatchServer.connect 'disk-watcher-server', (options) ->
		return unless options.path.match /\.coffee/

		targetPath = options.path.replace 'src', 'build'

		switch options.type
			when 'changed'
				runTests()

			when 'added'
				runTests()

	runTests()
