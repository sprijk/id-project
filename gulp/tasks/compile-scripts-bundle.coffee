browserify    = require 'browserify'
gulp          = require 'gulp'
log           = require 'id-debug'
vinylSource   = require 'vinyl-source-stream'
{ Transform } = require 'stream'

sourcePath      = './build/client/js/app/app.js'
targetDirectory = './build/client/js/app'

gulp.task 'compile-scripts-bundle', [ 'compile-scripts', 'compile-files' ], ->
	bundler = browserify
		entries: [ sourcePath ]
		extensions: [ '.js', '.json', '.jade' ]

	bundler.transform 'jadeify'
	bundler.transform 'debowerify'

	bundle = bundler.bundle debug: true

	bundle.on 'error', log.error.bind log

	bundle
		.pipe vinylSource 'app.bundle.js'
		.pipe gulp.dest targetDirectory
