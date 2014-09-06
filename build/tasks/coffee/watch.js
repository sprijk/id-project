var diskWatcher, enabled, fs, gulp, gulpCoffee, gulpLivereload, log, path, sourceDirectoryPath, targetDirectoryPath, watchEnabled, _ref;

fs = require("fs");

path = require("path");

gulp = require("gulp");

gulpCoffee = require("gulp-coffee");

gulpLivereload = require("gulp-livereload");

log = require("id-debug");

diskWatcher = require("../../lib/disk-watcher");

_ref = idProjectOptions.coffee, enabled = _ref.enabled, sourceDirectoryPath = _ref.sourceDirectoryPath, targetDirectoryPath = _ref.targetDirectoryPath;

watchEnabled = idProjectOptions.watch.enabled;

gulp.task("coffee:watch", ["coffee:compile", "livereload:run"], function(cb) {
  var compilePath, removePath;
  if (!(enabled === true && watchEnabled === true)) {
    log.info("Skipping browserify:watch: Disabled.");
    return cb();
  }
  compilePath = function(sourcePath) {
    var coffeeCompiler, sourceDirectory, targetDirectory;
    coffeeCompiler = gulpCoffee({
      bare: true
    });
    coffeeCompiler.on("error", log.error.bind(log));
    sourceDirectory = path.dirname(sourcePath);
    targetDirectory = sourceDirectory.replace(sourceDirectoryPath, targetDirectoryPath);
    return gulp.src(sourcePath).pipe(coffeeCompiler).pipe(gulp.dest(targetDirectory));
  };
  removePath = function(sourcePath) {
    var targetPath;
    targetPath = sourcePath.replace(sourceDirectoryPath, targetDirectoryPath).replace(".coffee", ".js");
    return fs.unlink(targetPath, function(error) {
      if (error) {
        return log.error(error);
      }
    });
  };
  diskWatcher.src().on("change", function(options) {
    if (!options.path.match(/\.coffee$/)) {
      return;
    }
    switch (options.type) {
      case "changed":
        return compilePath(options.path);
      case "added":
        return compilePath(options.path);
      case "deleted":
        return removePath(options.path);
    }
  });
});
