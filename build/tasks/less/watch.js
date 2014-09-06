var diskWatcher, enabled, entryFilePath, fs, gulp, gulpLess, gulpLivereload, log, path, targetDirectoryPath, watchEnabled, _ref;

fs = require("fs");

path = require("path");

gulp = require("gulp");

gulpLess = require("gulp-less");

gulpLivereload = require("gulp-livereload");

log = require("id-debug");

diskWatcher = require("../../lib/disk-watcher");

_ref = idProjectOptions.less, enabled = _ref.enabled, entryFilePath = _ref.entryFilePath, targetDirectoryPath = _ref.targetDirectoryPath;

watchEnabled = idProjectOptions.watch.enabled;

gulp.task("less:watch", ["less:compile", "livereload:run"], function(cb) {
  if (!(enabled === true && watchEnabled === true)) {
    log.info("Skipping less:watch: Disabled.");
    return cb();
  }
  fs.exists(entryFilePath, function(exists) {
    var compile;
    if (!exists) {
      log.info("Skipping less:compile: File `" + entryFilePath + "` not found.");
      return cb();
    }
    compile = function() {
      return gulp.src(entryFilePath).pipe(gulpLess()).pipe(gulp.dest(targetDirectoryPath)).pipe(gulpLivereload({
        auto: false
      }));
    };
    return diskWatcher.src().on("change", function(options) {
      if (!options.path.match(/\.less/)) {
        return;
      }
      return compile();
    });
  });
});
