gulp = require 'gulp'

srcWatch  = null
testWatch = null

module.exports =
	src: ->
		srcWatch or= gulp.watch 'src/**/*',  read: false
		srcWatch

	test: ->
		testWatch or= gulp.watch 'test/**/*', read: false
		testWatch
