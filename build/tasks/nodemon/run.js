var entryFilePath, fs, gulp, gulpNodemon, log, options, path, watchGlob, watchNodemon;

fs = require("fs");

path = require("path");

gulp = require("gulp");

gulpNodemon = require("gulp-nodemon");

log = require("id-debug");

options = idProjectOptions;

entryFilePath = options.nodemonEntryFilePath;

watchGlob = options.watchGlob;

watchNodemon = function() {
  var monitor;
  return monitor = gulpNodemon({
    script: entryFilePath,
    watch: watchGlob
  });
};

gulp.task("nodemon:run", ["compile"], function(cb) {
  if (options.nodemon !== true) {
    log.info("Skipping nodemon:run: Disabled.");
    return cb();
  }
  watchNodemon();
  cb();
});
