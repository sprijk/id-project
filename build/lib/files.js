var copy, fs, rimraf, rm;

fs = require('fs');

rimraf = require('rimraf');

copy = function(path, cb) {
  var readStream, targetPath, writeStream;
  targetPath = path.replace('src', 'build');
  readStream = fs.createReadStream(path);
  writeStream = fs.createWriteStream(targetPath);
  readStream.on('error', cb);
  writeStream.on('error', cb);
  writeStream.on('finish', cb);
  return readStream.pipe(writeStream);
};

rm = rimraf;

module.exports = {
  rm: rm,
  copy: copy
};
