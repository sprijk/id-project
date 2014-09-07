var enabled, entryFilePath, fs, gulp, gulpNodemon, log, options, path, watchGlob, watchNodemon;

fs = require("fs");

path = require("path");

gulp = require("gulp");

gulpNodemon = require("gulp-nodemon");

log = require("id-debug");

options = idProjectOptions.less;

enabled = options.enabled;

entryFilePath = path.resolve(options.entryFilePath);

watchGlob = options.watchGlob;

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
  log.debug("[nodemon:run] Entry file path: `" + entryFilePath + "`.");
  log.debug("[nodemon:run] Watch Globs: `" + (watchGlob.join(",")) + "`.");
  watchNodemon();
  cb();
});
