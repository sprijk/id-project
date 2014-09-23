log = require "id-debug"
lsr = require "lsr"

defaults = {}

defaults.sourceDirectoryPath = "./src"
defaults.targetDirectoryPath = "./build"

defaults.browserify =
	enabled:             true
	paths:               [ "#{defaults.targetDirectoryPath}/client/js/app" ]
	entryFilePath:       "#{defaults.targetDirectoryPath}/client/js/app/app.js"
	targetFilename:      "app.bundle.js"
	targetDirectoryPath: "#{defaults.targetDirectoryPath}/client/js/app"

defaults.clean =
	enabled:             true
	targetDirectoryPath: defaults.targetDirectoryPath

defaults.coffee =
	enabled:             true
	sourceDirectoryPath: defaults.sourceDirectoryPath
	targetDirectoryPath: defaults.targetDirectoryPath

defaults.copy =
	enabled:             true
	sourceDirectoryPath: defaults.sourceDirectoryPath
	targetDirectoryPath: defaults.targetDirectoryPath

defaults.documentation =
	enabled:             true
	sourceDirectoryPath: defaults.sourceDirectoryPath
	targetDirectoryPath: defaults.targetDirectoryPath

defaults.less =
	enabled:             true
	entryFilePath:       "#{defaults.sourceDirectoryPath}/client/less/app.less"
	targetDirectoryPath: "#{defaults.targetDirectoryPath}/client/css"

defaults.livereload =
	enabled:             true

defaults.nodemon =
	enabled:             true
	entryFilePath:       "./app.js"
	watchGlob:           [ "#{defaults.targetDirectoryPath}/server/**/*.js" ]

defaults.tests =
	enabled:             true
	directoryPath:       "./test"

defaults.watch =
	enabled:             true

applyDefaults = (options) ->
	#log.debug "options before", options

	for task, taskOptions of defaults
		for k, v of taskOptions
			unless options[task]?
				options[task] = {}

			unless options[task][k]?
				options[task][k] = v

	#log.debug "options after", options

module.exports = (options = {}) ->
	tasksDirectoryPath = "#{__dirname}/tasks"

	applyDefaults options

	global.idProjectOptions = options

	stats = lsr.sync tasksDirectoryPath

	for stat in stats
		unless stat.isDirectory()
			log.debug "Requiring module", stat.fullPath

			require stat.fullPath

	return
