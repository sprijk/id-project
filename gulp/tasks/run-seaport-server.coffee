net     = require 'net'
seaport = require 'seaport'

gulp = require 'gulp'

gulp.task 'run-seaport-server', (cb) ->
	# Attempt a connection.
	connection = net.connect 9000

	# When successful, continue.
	connection.on 'connect', cb

	# When unsuccessful, spawn a new Seaport server.
	connection.on 'error', ->
		seaportServer = seaport.createServer()
		seaportServer.listen 9000, cb

	return
