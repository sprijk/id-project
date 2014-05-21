clean         = require 'gulp-clean'
coffee        = require 'gulp-coffee'
cp            = require 'child_process'
filter        = require 'gulp-filter'
gulp          = require 'gulp'
header        = require 'gulp-header'
ignore        = require 'gulp-ignore'
jade          = require 'gulp-jade'
less          = require 'gulp-less'
nodemon       = require 'gulp-nodemon'
path          = require 'path'
rename        = require 'gulp-rename'
size          = require 'gulp-size'
templatizer   = require 'templatizer'
watch         = require 'gulp-watch'
{ Transform } = require 'stream'

log = console.log.bind console

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

# Filters out coffee files and compiles them.
# When the file is from the bin directory, add a header.
compileCoffee = (source, destination) ->
	log 'Compiling CoffeeScript.'

	coffeeFileFilter = filter [ "**/*.coffee", "**/*.litcoffee" ]
	binaryFileFilter = filter "#{config.directories.bin}/**/*"

	coffeeCompiler = coffee bare: true

	coffeeCompiler.on 'error', (error) ->
		console.log error.stack

	source
		.pipe coffeeFileFilter
		.pipe coffeeCompiler

		.pipe binaryFileFilter
		.pipe header '#!/usr/bin/env node\n'
		.pipe binaryFileFilter.restore()

		.pipe destination

# Filters out less files and sends them to the templateCompiler.
compileLess = (source, destination) ->
	compile = ->
		log 'Compiling Less.'

		source      = gulp.src "#{config.directories.source}/#{config.directories.client}/less/app.less"
		destination = gulp.dest "#{config.directories.build}/#{config.directories.client}/css"
		source
			.pipe less()
			.pipe destination

	# If there is no source, compile everything.
	# Sends one message to the lessCompiler, just compiling everything.
	unless source
		compile()

	# If there is source, compile the filtered less files.
	else
		compiled = false

		lessFileFilter = filter [ "**/*.less" ]

		source
			.pipe lessFileFilter

			# Filter already filters for less files so we don't have to match in the
			# rename.
			# Rename provides a callback so we can compile everything.
			.pipe rename (path) ->
				unless compiled
					compile()

					compiled = true

				path

# Filters out jade files and sends them to the templateCompiler.
compileJade = (source, destination) ->
	compile = ->
		log 'Compiling Jade.'

		source      = path.resolve __dirname, "#{config.directories.source}/#{config.directories.client}/templates"
		destination = path.resolve __dirname, "#{config.directories.build}/#{config.directories.client}/js/templates.js"
		try
			templatizer source, destination
		catch error
			console.log error.stack or error.message or error

	# If there is no source, compile everything.
	# Sends one message to the jadeCompiler, just compiling everything.
	unless source
		compile()

	# If there is source, compile the filtered jade files.
	else
		compiled = false

		jadeFileFilter = filter [ "**/*.jade" ]

		source
			.pipe jadeFileFilter

			# Filter already filters for jade files so we don't have to match in the
			# rename.
			# Rename provides a callback so we can compile everything.
			.pipe rename (path) ->
				unless compiled
					compile()

					compiled = true

				path

copyFiles = (source, destination) ->
	log 'Copying Files.'

	# If there is no source, compile everything.
	# Sends one message to the jadeCompiler, just compiling everything.
	unless source
		source = gulp.src [
			"#{config.directories.source}/**/*"
			"!**/*.coffee"
			"!**/*.litcoffee"
			"!**/*.less"

			# Copy server jade, but don't copy client jade
			"!#{config.directories.client}/**/*.jade"
		]

		destination = gulp.dest "#{config.directories.build}"

		source
			.pipe destination

	# If there is source, compile the filtered jade files.
	else
		plainFileFilter = filter [
			"**/*.coffee"
			"**/*.litcoffee"
			"**/*.less"

			# Copy server jade, but don't copy client jade
			"#{config.directories.client}/**/*.jade"
		]

		source
			.pipe plainFileFilter
			.pipe destination

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

# Cleans all JavaScript and CSS files. Leaves all other files.
gulp.task 'clean', ->
	gulp.src ["#{config.directories.build}/**/*.js", "#{config.directories.build}/**/*.css"], read: false
		.pipe clean force: true

gulp.task 'copy', ['clean'], (cb) ->
	copyFiles()
	cb()

gulp.task 'compile:coffee', ['clean'], ->
	source      = gulp.src [ "#{config.directories.source}/**/*.coffee", "#{config.directories.source}/**/*.litcoffee" ]
	destination = gulp.dest "#{config.directories.build}"

	compileCoffee source, destination

gulp.task 'compile:less', ['clean'], (cb) ->
	compileLess()
	cb()

gulp.task 'compile:templates', ['clean'], (cb) ->
	compileJade()
	cb()

gulp.task 'compile', [
	'compile:coffee'
	'compile:less'
	'compile:templates'
]

gulp.task 'test', ['compile', 'copy'], (cb) ->
	watch {
		name: 'watch'
		glob: [
			"#{config.directories.source}/**/*.coffee"
			"#{config.directories.source}/**/*.litcoffee"
			"#{config.directories.test}/**/*.coffee"
			"#{config.directories.test}/**/*.litcoffee"
		]
		emitOnGlob: true
	}, (source) ->
		destination = gulp.dest "#{config.directories.build}"

		compileCoffee source, destination

		# TODO: add an optional callback to compileCoffee, so we can do this
		# exactly after that.
		setTimeout (->
			runTests false, config.test.reporter
		), 1000

gulp.task 'watch', ['compile', 'copy'], ->
	watch {
		name:       'watch'
		glob:       [ "#{config.directories.source}/**/*" ]
		emitOnGlob: false
	}, (source) ->
		destination = gulp.dest "#{config.directories.build}"

		# These happen in parallel.
		compileCoffee source, destination
		compileLess   source, destination
		compileJade   source, destination
		copyFiles     source, destination

	# Do this in a setTimeout to not trigger restarts while the watch compile
	# targets are still running.
	setTimeout (->
		# To put debugging on add the option verbose: true
		monitor = nodemon
			script: 'app.js'
			watch:  [ "#{config.directories.build}" ]
			ext:    'js css html'
	), 10

gulp.task 'default', [
	'clean'
	'compile'
]
