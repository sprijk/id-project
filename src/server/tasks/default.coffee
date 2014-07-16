gulp = require 'gulp'

# TODO: Find a way around having to use gulp.start to start a task that is many
#       other tasks and give it a dependency.
gulp.task 'default', [ 'clean' ], ->
	gulp.start 'watch'
