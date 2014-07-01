net = require 'net'

gulp    = require 'gulp'
seaport = require 'seaport'

watcher = (path) -> gulp.watch path, read: false

createServer = (path) ->
	watchEmitter = watcher path

	seaportClient = seaport.connect 9000

	server = net.createServer (clientStream) ->
		clientHandler = (options) ->
			message = "#{options.type}:#{options.path}"
			clientStream.write message

		watchEmitter.addListener 'change', clientHandler

		clientStream.on 'close', ->
			watchEmitter.removeListener 'change', clientHandler

	server.start = (name, cb) ->
		server.listen (seaportClient.register "gulp:#{name}"), cb

	server

connect = (watchServerName, cb) ->
	seaportClient = seaport.connect 9000

	seaportClient.get "gulp:#{watchServerName}", (ps) ->
		watchServerClientStream = net.connect ps[0].port

		watchServerClientStream.on 'data', (chunk) ->
			[ type, path ] = chunk.toString().split ':'

			cb
				type: type
				path: path

module.exports = 
	connect:      connect
	createServer: createServer
