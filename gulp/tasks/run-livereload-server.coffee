net = require 'net'

gulp           = require 'gulp'
gulpLivereload = require 'gulp-livereload'
log            = require 'id-debug'

gulp.task 'run-livereload-server', (cb) ->
	# Attempt a connection.
	connection = net.connect 35729

	# When successful, continue.
	connection.on 'connect', ->
		cb()

	# When unsuccessful, spawn a new server.
	connection.on 'error', ->
		log.info 'Livereload server does not exist. Starting one.'
		gulpLivereload.listen()
		cb()

	return
