browserify     = require 'browserify'
cp             = require 'child_process'
es             = require 'event-stream'
fs             = require 'fs'
gulp           = require 'gulp'
gulpClean      = require 'gulp-clean'
gulpCoffee     = require 'gulp-coffee'
gulpFilter     = require 'gulp-filter'
gulpHeader     = require 'gulp-header'
gulpLess       = require 'gulp-less'
gulpLivereload = require 'gulp-livereload'
gulpNodemon    = require 'gulp-nodemon'
gulpWatch      = require 'gulp-watch'
livereload     = require 'tiny-lr'
path           = require 'path'
rimraf         = require 'rimraf'
source         = require 'vinyl-source-stream'
watchify       = require 'watchify'

config =
	directories:
		source: 'src'
		build:  'build'
		test:   'src/test'

		bin:           'bin'
		lib:           'lib'
		client:        'client'
		server:        'server'
		documentation: 'doc'

	test:
		reporter: 'spec'

liveReloadServer = livereload()
liveReloadServer.listen 35729, (error) ->
	console.log error if error

coffeeCompiler = ->
	filter   = gulpFilter [ "**/*.coffee", "**/*.litcoffee" ]
	compiler = gulpCoffee bare: true

	compiler.on 'error', (error) ->
		console.log error.stack

	es.pipeline filter, compiler

executablePrepender = ->
	filter  = gulpFilter "#{config.directories.bin}/**/*"
	header  = gulpHeader '#!/usr/bin/env node\n'
	restore = filter.restore()

	es.pipeline filter, header, restore

compileCoffee = (source, destination) ->
	source
		.pipe coffeeCompiler()
		.pipe executablePrepender()
		.pipe destination

# Filters out less files and sends them to the templateCompiler.
compileLess = (cb) ->
	sourceFilePath      = gulp.src "#{config.directories.source}/#{config.directories.client}/less/app.less"
	targetFileDirectory = gulp.dest "#{config.directories.build}/#{config.directories.client}/css"

	if cb
		targetFileDirectory.once 'end', cb

	sourceFilePath
		.pipe gulpLess()
		.pipe targetFileDirectory
		.pipe gulpLivereload liveReloadServer

	return

copyFiles = (sourceStream, destinationStream) ->
	plainFileFilter = gulpFilter [
		"!**/*.coffee"
		"!**/*.litcoffee"
		"!**/*.less"
	]

	sourceStream
		.pipe plainFileFilter
		.pipe destinationStream
		.pipe gulpLivereload liveReloadServer

runTests = (exit, reporter, cb) ->
	mochaInstance = cp.spawn 'mocha', [
		'--recursive'
		'--compilers'
		'coffee:coffee-script/register'
		'--reporter'
		config.test.reporter
		config.directories.test
	]

	mochaInstance.stdout.on 'data', (data) ->
		process.stdout.write data

	mochaInstance.stderr.on 'data', (data) ->
		process.stdout.write data

	mochaInstance.once 'close', ->
		if exit
			process.exit()

		else
			cb?()

watchBrowserify = ->
	sourceFilePath      = "#{__dirname}/#{config.directories.build}/#{config.directories.client}/js/app.js"
	targetFileDirectory = "#{__dirname}/#{config.directories.build}/#{config.directories.client}/js"

	bundler = watchify sourceFilePath

	bundler.transform 'jadeify'

	compile = ->
		bundler.bundle debug: true
			.pipe source 'app.bundle.js'
			.pipe gulp.dest targetFileDirectory
			.pipe gulpLivereload liveReloadServer

	bundler.on 'update', compile

	bundler.on 'error', (error) ->
		console.error error

	compile()

watchFiles = ->
	gulpWatch {
		name: 'watch'
		glob: [
			"#{config.directories.source}/**/*"
		]
		emitOnGlob: false
	}, (sourceStream) ->
		destinationStream = gulp.dest "#{config.directories.build}"

		compileCoffee sourceStream, destinationStream
		copyFiles     sourceStream, destinationStream

		lessFilter = gulpFilter "**/*.less"
		lessFilter.on 'data', compileLess

		sourceStream
			.pipe lessFilter

watchTest = ->
	gulpWatch {
		name: 'watch'
		glob: [
			"#{config.directories.source}/**/*.coffee"
			"#{config.directories.source}/**/*.litcoffee"
			"#{config.directories.test}/**/*.coffee"
			"#{config.directories.test}/**/*.litcoffee"
		]
		emitOnGlob: true
	}, (sourceStream) ->
		destinationStream = gulp.dest "#{config.directories.build}"

		destinationStream.on 'end', runTests.bind false, config.test.reporter

		compileCoffee sourceStream, destinationStream

watchNodemon = ->
	monitor = gulpNodemon
		#verbose: true
		script: 'app.js'
		watch:  [
			#"#{config.directories.build}/#{config.directories.client}/css/app.css"
			#"#{config.directories.build}/#{config.directories.client}/js/app.bundle.js"
			"#{config.directories.build}/#{config.directories.server}/**/*.js"
		]

gulp.task 'clean', (cb) ->
	rimraf 'build', (error) ->
		return cb error if error
		fs.mkdir 'build', cb

gulp.task 'copy', ['clean'], ->
	sourceStream = gulp.src [
		"#{config.directories.source}/**/*"
		"!**/*.coffee"
		"!**/*.litcoffee"
		"!**/*.less"
	]

	destinationStream = gulp.dest "#{config.directories.build}"

	sourceStream
		.pipe destinationStream
		.pipe gulpLivereload liveReloadServer

gulp.task 'compile:coffee', ['clean'], ->
	sourceStream      = gulp.src [ "#{config.directories.source}/**/*.coffee", "#{config.directories.source}/**/*.litcoffee" ]
	destinationStream = gulp.dest "#{config.directories.build}"

	compileCoffee sourceStream, destinationStream

gulp.task 'compile:less', ['clean'], (cb) ->
	compileLess cb

gulp.task 'compile:browserify', ['copy', 'compile:coffee'], (cb) ->
	sourceFilePath      = "#{__dirname}/#{config.directories.build}/#{config.directories.client}/js/app.js"
	targetFileDirectory = gulp.dest "#{__dirname}/#{config.directories.build}/#{config.directories.client}/js"

	targetFileDirectory.once 'end', ->
		console.log 'end'
		cb()

	bundler = browserify()
	bundler.add sourceFilePath

	bundler.transform 'jadeify'

	bundler.on 'error', (error) ->
		console.error error
		cb()

	bundler.bundle debug: true
		.pipe source 'app.bundle.js'
		.pipe targetFileDirectory

gulp.task 'compile', [
	'compile:browserify'
	'compile:coffee'
	'compile:less'
]

gulp.task 'test', ['compile', 'copy'], (cb) ->
	watchTest()

gulp.task 'watch', ['compile', 'copy'], ->
	watchFiles()
	watchBrowserify()
	watchNodemon()

gulp.task 'default', [
	'clean'
	'compile'
]
