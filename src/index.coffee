log = require "id-debug"
lsr = require "lsr"

defaultOptions =
	browserify:                    true
	browserifyEntryFilePath:       "./build/client/js/app/app.js"
	browserifyTargetFilename:      "app.bundle.js"
	browserifyTargetDirectoryPath: "./build/client/js/app"
	clean:                         true
	coffee:                        true
	copy:                          true
	documentation:                 true
	less:                          true
	lessEntryFilePath:             "./src/client/less/app.less"
	lessTargetDirectoryPath:       "./build/client/css"
	livereload:                    true
	nodemon:                       true
	nodemonEntryFilePath:          "./app.js"
	nodemonWatchGlob:              [ "build/server/**/*.js" ]
	tests:                         true
	testsDirectoryPath:            "./test"
	watch:                         true

module.exports = (options = {}) ->
	tasksDirectoryPath = "#{__dirname}/tasks"

	for k, v of defaultOptions
		if options[k] is undefined
			options[k] = v

	global.idProjectOptions = options

	stats = lsr.sync tasksDirectoryPath

	for stat in stats
		unless stat.isDirectory()
			log.debug "Requiring module", stat.fullPath

			require stat.fullPath

	return
