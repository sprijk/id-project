net = require 'net'

gulp    = require 'gulp'
seaport = require 'seaport'

diskWatcherServer = require '../lib/disk-watcher-server'

gulp.task 'run-disk-watcher-server', [ 'run-seaport-server' ], (cb) ->
	server = diskWatcherServer.createServer [ 'src/**/*', 'test/**/*' ]
	server.start 'disk-watcher-server', cb
