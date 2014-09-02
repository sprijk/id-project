fs = require "fs"

rimraf = require "rimraf"

copy = (path, cb) ->
	targetPath = path.replace "src", "build"

	readStream  = fs.createReadStream path
	writeStream = fs.createWriteStream targetPath

	readStream.on "error", cb
	writeStream.on "error", cb
	writeStream.on "finish", cb

	readStream
		.pipe writeStream

rm = rimraf

module.exports =
	rm:   rm
	copy: copy
