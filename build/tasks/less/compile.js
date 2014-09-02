var entryFilePath, fs, gulp, gulpLess, log, options;

fs = require("fs");

gulp = require("gulp");

gulpLess = require("gulp-less");

log = require("id-debug");

entryFilePath = "src/client/less/app.less";

options = idProjectOptions;

gulp.task("less:compile", function(cb) {
  if (options.less !== true) {
    log.info("Skipping less:compile: Disabled.");
    return cb();
  }
  fs.exists(entryFilePath, function(exists) {
    if (!exists) {
      log.info("Skipping less:compile: File `" + entryFilePath + "` not found.");
      return cb();
    }
    return gulp.src(entryFilePath).pipe(gulpLess()).pipe(gulp.dest("build/client/css")).on("end", cb);
  });
});
