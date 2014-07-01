fs   = require 'fs'
path = require 'path'

gulp       = require 'gulp'
gulpCoffee = require 'gulp-coffee'

spawnerServer   = require '../lib/spawner-server'
diskWatcherServer = require '../lib/disk-watcher-server'

#gulp.task 'watch-server', [ 'compile', 'run-spawner-server' ], (cb) ->
#	spawnerClient = spawnerServer.createClient 'run-spawner-server'
#
#	spawnerClient.connect ->
#		watchClient = diskWatcherServer.connect 'disk-watcher-server', (options) ->
#			return unless options.path.match /src\/server\/.*\.coffee/
#
#			spawnerClient.restart()
#
#		spawnerClient.start()

gulpNodemon = require 'gulp-nodemon'

watchNodemon = ->
	monitor = gulpNodemon
		#verbose: true
		script: 'index.js'
		watch:  [ 'build/server/**/*.js' ]

gulp.task 'watch-server', [ 'compile' ], (cb) ->
	watchNodemon()
	cb()
