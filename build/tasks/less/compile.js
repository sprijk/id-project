var enabled, entryFilePath, fs, gulp, gulpLess, log, targetDirectoryPath, _ref;

fs = require("fs");

gulp = require("gulp");

gulpLess = require("gulp-less");

log = require("id-debug");

_ref = idProjectOptions.less, enabled = _ref.enabled, entryFilePath = _ref.entryFilePath, targetDirectoryPath = _ref.targetDirectoryPath;

gulp.task("less:compile", function(cb) {
  if (enabled !== true) {
    log.info("Skipping less:compile: Disabled.");
    return cb();
  }
  fs.exists(entryFilePath, function(exists) {
    if (!exists) {
      log.info("Skipping less:compile: File `" + entryFilePath + "` not found.");
      return cb();
    }
    return gulp.src(entryFilePath).pipe(gulpLess()).pipe(gulp.dest(targetDirectoryPath)).on("end", cb);
  });
});
