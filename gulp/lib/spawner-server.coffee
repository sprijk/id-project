cp  = require 'child_process'
net = require 'net'

seaport = require 'seaport'

class Spawner
	constructor: (options) ->
		@path    = options.path
		@running = false
		@process = null

	_getProcess: ->
		cp.spawn 'node', [ @path ]

	_connectChildProcess: (childProcess) ->
		childProcess.on 'SIGINT', ->
			console.log 'SIGINT'
			childProcess.kill()
			process.kill()

		childProcess.on 'SIGTERM', ->
			console.log 'SIGTERM'
			childProcess.kill()
			process.kill()

		childProcess.stdout.on 'data', (chunk) ->
			process.stdout.write chunk

		childProcess.stderr.on 'data', (chunk) ->
			process.stderr.write chunk

	start: ->
		@process = @_getProcess()

		@_connectChildProcess @process

		@running = true

	stop: ->
		return unless @running

		@process.kill()
		@process = null
		@running = false

	restart: ->
		@stop()
		@start()

createServer = (name) ->
	seaportClient = seaport.connect 9000

	spawner = new Spawner path: '.'

	server = net.createServer (clientStream) ->
		clientStream.on 'data', (chunk) ->
			spawner[chunk.toString()]()

	server.start = (cb) ->
		server.listen (seaportClient.register "gulp:#{name}"), cb

	server

createClient = (name) ->
	seaportClient = seaport.connect 9000

	client =
		clientStream: null

		connect: (cb) ->
			seaportClient.get "gulp:#{name}", (ps) ->
				client.clientStream = net.connect ps[0].port

				cb()

		restart: ->
			client.clientStream.write 'restart'

		start: ->
			client.clientStream.write 'start'

		stop: ->
			client.clientStream.write 'stop'

	client

module.exports =
	Spawner:      Spawner
	createClient: createClient
	createServer: createServer
