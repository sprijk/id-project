var copy, diskWatcher, fs, gulp, gulpLivereload, log, options, reloadPath, rm, _ref;

fs = require("fs");

gulp = require("gulp");

gulpLivereload = require("gulp-livereload");

log = require("id-debug");

diskWatcher = require("../../lib/disk-watcher");

_ref = require("../../lib/files"), copy = _ref.copy, rm = _ref.rm;

options = idProjectOptions;

reloadPath = function(path) {
  if (path.match(/\.jade$/)) {
    return;
  }
  return gulpLivereload({
    auto: false
  }).write({
    path: path
  });
};

gulp.task("copy:watch", ["copy:compile", "livereload:run"], function(cb) {
  if (!(options.copy === true && options.watch === true)) {
    log.info("Skipping copy:watch: Disabled.");
    return cb();
  }
  diskWatcher.src().on("change", function(options) {
    if (options.path.match(/\.(coffee|less)/)) {
      return;
    }
    switch (options.type) {
      case "changed":
        return copy(options.path, function(error) {
          if (error) {
            log.error(error);
          }
          return reloadPath(options.path);
        });
      case "added":
        return copy(options.path, function(error) {
          if (error) {
            log.error(error);
          }
          return reloadPath(options.path);
        });
      case "deleted":
        return rm(options.path, function(error) {
          if (error) {
            return log.error(error);
          }
        });
    }
  });
});
