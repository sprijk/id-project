var copy, diskWatcher, enabled, excluded, fs, gulp, gulpLivereload, gulpTap, log, minimatch, options, path, reloadPath, rm, sourceDirectoryPath, targetDirectoryPath, watchEnabled, _ref;

fs = require("fs");

path = require("path");

gulp = require("gulp");

gulpLivereload = require("gulp-livereload");

gulpTap = require("gulp-tap");

log = require("id-debug");

minimatch = require("minimatch");

diskWatcher = require("../../lib/disk-watcher");

_ref = require("../../lib/files"), copy = _ref.copy, rm = _ref.rm;

options = idProjectOptions.copy;

enabled = options.enabled;

excluded = options.excluded;

sourceDirectoryPath = path.resolve(options.sourceDirectoryPath);

targetDirectoryPath = path.resolve(options.targetDirectoryPath);

watchEnabled = idProjectOptions.watch.enabled;

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
  if (!(enabled === true && watchEnabled === true)) {
    log.info("Skipping copy:watch: Disabled.");
    return cb();
  }
  log.debug("[copy:watch] Source directory path: `" + sourceDirectoryPath + "`.");
  log.debug("[copy:watch] Target directory path: `" + targetDirectoryPath + "`.");
  diskWatcher.src().on("change", function(options) {
    var exclude, _i, _len;
    log.warning("Detected change", options);
    for (_i = 0, _len = excludes.length; _i < _len; _i++) {
      exclude = excludes[_i];
      log.warning("trying exclude", exclude);
      if (minimatch(options.path, exclude)) {
        log.warning("exclude matched!", options.path, exclude);
        return;
      }
    }
    switch (options.type) {
      case "changed":
        log.debug("[copy:watch] Copying: `" + options.path + "`.");
        return copy(options.path, function(error) {
          if (error) {
            log.error(error);
          }
          return reloadPath(options.path);
        });
      case "added":
        log.debug("[copy:watch] Copying: `" + options.path + "`.");
        return copy(options.path, function(error) {
          if (error) {
            log.error(error);
          }
          return reloadPath(options.path);
        });
      case "deleted":
        log.debug("[copy:watch] Removing: `" + options.path + "`.");
        return rm(options.path, function(error) {
          if (error) {
            return log.error(error);
          }
        });
    }
  });
});
