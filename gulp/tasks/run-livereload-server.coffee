gulp           = require 'gulp'
gulpLivereload = require 'gulp-livereload'
net            = require 'net'
seaport        = require 'seaport'

gulp.task 'run-livereload-server', (cb) ->
	# Attempt a connection.
	connection = net.connect 35729

	# When successful, continue.
	connection.on 'connect', cb

	# When unsuccessful, spawn a new Seaport server.
	connection.on 'error', ->
		gulpLivereload.listen cb

	return
