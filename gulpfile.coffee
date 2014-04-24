clean       = require 'gulp-clean'
coffee      = require 'gulp-coffee'
gulp        = require 'gulp'
ignore      = require 'gulp-ignore'
jade        = require 'gulp-jade'
less        = require 'gulp-less'
mocha       = require 'gulp-spawn-mocha'
nodemon     = require 'gulp-nodemon'
templatizer = require 'templatizer'
watch       = require 'gulp-watch'
path        = require 'path'

log = console.log.bind console

config =
	directories:
		source: './src'
		build: './build'

		lib:           'lib'
		client:        'client'
		server:        'server'
		test:          'test'
		documentation: 'doc'

compileCoffee = (source, destination) ->
	coffeeCompiler = coffee bare: true

	coffeeCompiler.on 'error', (error) ->
		console.log error.stack

	source
		.pipe coffeeCompiler
		.pipe destination

compileTemplates = (source, destination) ->
	try
		templatizer source, destination

runTests = (exit, reporter, cb) ->
	mochaInstance = mocha
		reporter: reporter

	# Do nothing here
	mochaInstance.on 'error', (error) ->

	mochaInstance.on 'end', ->
		if exit
			process.exit()
		else
			cb()

	gulp.src "#{config.directories.build}/#{config.directories.test}/**/*.js", read: false
		.pipe mochaInstance
		.on 'error', (error) ->
			# do nothing here

gulp.task 'clean', ->
	gulp.src "#{config.directories.build}/*", read: false
		.pipe clean force: true

gulp.task 'copy', ['clean'], ->
	gulp.src [ "#{config.directories.source}/**/*", "!**/*.coffee", "!**/*.litcoffee", "!**/*.less" ]
		.pipe gulp.dest "#{config.directories.build}"

gulp.task 'compile:coffee', ['clean'], ->
	source = gulp.src [ "#{config.directories.source}/**/*.coffee", "#{config.directories.source}/**/*.litcoffee" ]

	source
		.pipe coffee bare: true
		.pipe gulp.dest "#{config.directories.build}"

gulp.task 'compile:less', ['clean'], ->
	gulp.src "#{config.directories.source}/#{config.directories.client}/less/app.less"
		.pipe less()
		.pipe gulp.dest "#{config.directories.build}/#{config.directories.client}/css"

gulp.task 'compile:templates', ['clean'], (cb) ->
	source      = path.resolve __dirname, "#{config.directories.source}/#{config.directories.client}/templates"
	destination = path.resolve __dirname, "#{config.directories.build}/#{config.directories.client}/js/templates.js"

	compileTemplates source, destination

	cb()

gulp.task 'compile', [
	'compile:coffee'
	'compile:less'
	'compile:templates'
]

gulp.task 'test', ['compile', 'copy'], (cb) ->
	runTests true, 'spec', cb
	return

gulp.task 'watch', ['compile', 'copy'], ->
	watch {
		name: 'watch.coffee'
		glob: "#{config.directories.source}/**/*.coffee"
	}, (source) ->
		compileCoffee source, gulp.dest "#{config.directories.build}"

	watch {
		name: 'watch.litcoffee'
		glob: "#{config.directories.source}/**/*.litcoffee"
	}, (source) ->
		compileCoffee source, gulp.dest "#{config.directories.build}"

	watch {
		name: 'watch.less'
		glob: "#{config.directories.source}/**/*.less"
	}, (files) ->
		gulp.src "#{config.directories.source}/#{config.directories.client}/less/app.less"
			.pipe less()
			.pipe gulp.dest "#{config.directories.build}/#{config.directories.client}/css"

	watch {
		name: 'watch.jade'
		glob: "#{config.directories.source}/**/*.jade"
	}, (files) ->
		source      = path.resolve __dirname, "#{config.directories.source}/#{config.directories.client}/templates"
		destination = path.resolve __dirname, "#{config.directories.build}/#{config.directories.client}/js/templates.js"

		compileTemplates source, destination

	watch {
		name: 'watch.copy'
		glob: "#{config.directories.source}/**/*"
	}, (files) ->
		files
			.pipe ignore.exclude '**/*.less'
			.pipe ignore.exclude '**/*.coffee'
			.pipe ignore.exclude '**/*.litcoffee'
			.pipe ignore.exclude '**/*.jade'
			.pipe gulp.dest "#{config.directories.build}"

	setTimeout (->
		monitor = nodemon
			script: 'app.js'
			watch:  [ "#{config.directories.build}" ]
			ext:    'js css html'
			verbose: true
	), 10

gulp.task 'default', [
	'watch'
]
