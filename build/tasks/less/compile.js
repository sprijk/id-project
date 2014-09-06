var entryFilePath, fs, gulp, gulpLess, log, options, targetDirectoryPath;

fs = require("fs");

gulp = require("gulp");

gulpLess = require("gulp-less");

log = require("id-debug");

options = idProjectOptions;

entryFilePath = options.lessEntryFilePath;

targetDirectoryPath = options.lessTargetDirectoryPath;

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
    return gulp.src(entryFilePath).pipe(gulpLess()).pipe(gulp.dest(lessTargetDirectoryPath)).on("end", cb);
  });
});
