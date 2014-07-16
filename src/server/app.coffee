log = require 'id-debug'
lsr = require 'lsr'

defaultOptions =
	browserify:    true
	clean:         true
	coffee:        true
	copy:          true
	documentation: true
	less:          true
	livereload:    true
	nodemon:       true
	tests:         true
	watch:         true

module.exports = (options = {}) ->
	tasksDirectoryPath = "#{__dirname}/tasks"

	for k, v of defaultOptions
		if options[k] is undefined
			options[k] = v

	global.idProjectOptions = options

	stats = lsr.sync tasksDirectoryPath

	for stat in stats
		unless stat.isDirectory()
			require stat.fullPath
