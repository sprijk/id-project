gulp    = require 'gulp'
seaport = require 'seaport'

spawnerServer = require '../lib/spawner-server'

gulp.task 'run-spawner-server', [ 'run-seaport-server' ], (cb) ->
	server = spawnerServer.createServer 'run-spawner-server'
	server.start cb
