var enabled, entryFilePath, fs, gulp, gulpNodemon, log, path, watchGlob, watchNodemon, _ref;

fs = require("fs");

path = require("path");

gulp = require("gulp");

gulpNodemon = require("gulp-nodemon");

log = require("id-debug");

_ref = idProjectOptions.nodemon, enabled = _ref.enabled, entryFilePath = _ref.entryFilePath, watchGlob = _ref.watchGlob;

watchNodemon = function() {
  return gulpNodemon({
    script: entryFilePath,
    watch: watchGlob
  });
};

gulp.task("nodemon:run", ["compile"], function(cb) {
  if (enabled !== true) {
    log.info("Skipping nodemon:run: Disabled.");
    return cb();
  }
  watchNodemon();
  cb();
});
