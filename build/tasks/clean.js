var cleanBuildDirectory, gulp, log, options;

gulp = require('gulp');

log = require('id-debug');

cleanBuildDirectory = require('../lib/clean').cleanBuildDirectory;

options = idProjectOptions;

gulp.task('clean', function(cb) {
  if (options.clean !== true) {
    log.info("Skipping clean: Disabled.");
    return cb();
  }
  cleanBuildDirectory('./build', cb);
});
