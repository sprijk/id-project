fs   = require 'fs'
path = require 'path'

gulp           = require 'gulp'
gulpLivereload = require 'gulp-livereload'
log            = require 'id-debug'
vinylSource    = require 'vinyl-source-stream'
watchify       = require 'watchify'

sourcePath      = './build/client/js/app/app.js'
targetDirectory = './build/client/js/app'

gulp.task 'watch-scripts-bundle', [ 'compile-scripts-bundle', 'run-livereload-server' ], (cb) ->
	bundler = watchify
		entries: [ sourcePath ]
		extensions: [ '.js', '.json', '.jade' ]

	bundler.transform 'jadeify'
	bundler.transform 'debowerify'

	compile = ->
		bundle = bundler.bundle debug: true

		bundle.on 'error', log.error.bind log

		bundle
			.pipe vinylSource 'app.bundle.js'
			.pipe gulp.dest targetDirectory
			.pipe gulpLivereload auto: false

	bundler.on 'update', compile

	# Needed for watchify to start watching..
	compile()

	return
