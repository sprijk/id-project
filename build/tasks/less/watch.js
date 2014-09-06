var diskWatcher, entryFilePath, fs, gulp, gulpLess, gulpLivereload, log, options, path, targetDirectoryPath;

fs = require("fs");

path = require("path");

gulp = require("gulp");

gulpLess = require("gulp-less");

gulpLivereload = require("gulp-livereload");

log = require("id-debug");

diskWatcher = require("../../lib/disk-watcher");

options = idProjectOptions;

entryFilePath = options.lessEntryFilePath;

targetDirectoryPath = options.lessTargetDirectoryPath;

gulp.task("less:watch", ["less:compile", "livereload:run"], function(cb) {
  if (!(options.less === true && options.watch === true)) {
    log.info("Skipping less:watch: Disabled.");
    return cb();
  }
  fs.exists(entryFilePath, function(exists) {
    var compilePath, removePath;
    if (!exists) {
      log.info("Skipping less:compile: File `" + entryFilePath + "` not found.");
      return cb();
    }
    compilePath = function(sourcePath) {
      var sourceDirectory;
      sourceDirectory = path.dirname(sourcePath);
      return gulp.src(sourcePath).pipe(gulpLess()).pipe(gulp.dest(targetDirectoryPath)).pipe(gulpLivereload({
        auto: false
      }));
    };
    removePath = function(sourcePath) {
      var targetPath;
      targetPath = sourcePath.replace("src", "build").replace(".less", ".css").replace("/less", "/css");
      return fs.unlink(targetPath, function(error) {
        if (error) {
          return log.error(error);
        }
      });
    };
    return diskWatcher.src().on("change", function(options) {
      if (!options.path.match(/\.less/)) {
        return;
      }
      switch (options.type) {
        case "changed":
          return compilePath(entryFilePath);
        case "added":
          return compilePath(entryFilePath);
        case "deleted":
          return removePath(options.path);
      }
    });
  });
});
