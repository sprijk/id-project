var entryFilePath, fs, gulp, gulpLivereload, log, options, path, targetDirectory, vinylSource, watchify;

fs = require('fs');

path = require('path');

gulp = require('gulp');

gulpLivereload = require('gulp-livereload');

log = require('id-debug');

vinylSource = require('vinyl-source-stream');

watchify = require('watchify');

entryFilePath = './build/client/js/app/app.js';

targetDirectory = './build/client/js/app';

options = idProjectOptions;

gulp.task('browserify:watch', ['browserify:compile', 'livereload:run'], function(cb) {
  if (!(options.browserify === true && options.watch === true)) {
    log.info("Skipping browserify:watch: Disabled.");
    return cb();
  }
  fs.exists(entryFilePath, function(exists) {
    var bundler, compile;
    if (!exists) {
      log.info("Skipping browserify:watch: File `" + entryFilePath + "` not found.");
      return cb();
    }
    bundler = watchify({
      entries: [entryFilePath],
      extensions: ['.js', '.json', '.jade']
    });
    bundler.transform('jadeify');
    bundler.transform('debowerify');
    compile = function() {
      var bundle;
      bundle = bundler.bundle({
        debug: true
      });
      bundle.on('error', log.error.bind(log));
      return bundle.pipe(vinylSource('app.bundle.js')).pipe(gulp.dest(targetDirectory)).pipe(gulpLivereload({
        auto: false
      }));
    };
    bundler.on('update', compile);
    compile();
  });
});
