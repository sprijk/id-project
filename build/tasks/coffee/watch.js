var diskWatcher, fs, gulp, gulpCoffee, gulpLivereload, log, options, path;

fs = require("fs");

path = require("path");

gulp = require("gulp");

gulpCoffee = require("gulp-coffee");

gulpLivereload = require("gulp-livereload");

log = require("id-debug");

diskWatcher = require("../../lib/disk-watcher");

options = idProjectOptions;

gulp.task("coffee:watch", ["coffee:compile", "livereload:run"], function(cb) {
  var compilePath, removePath;
  if (!(options.coffee === true && options.watch === true)) {
    log.info("Skipping browserify:watch: Disabled.");
    return cb();
  }
  compilePath = function(sourcePath) {
    var buildDirectory, coffeeCompiler, sourceDirectory;
    coffeeCompiler = gulpCoffee({
      bare: true
    });
    coffeeCompiler.on("error", log.error.bind(log));
    sourceDirectory = path.dirname(sourcePath);
    buildDirectory = sourceDirectory.replace("src", "build");
    return gulp.src(sourcePath).pipe(coffeeCompiler).pipe(gulp.dest(buildDirectory));
  };
  removePath = function(sourcePath) {
    var targetPath;
    targetPath = sourcePath.replace("src", "build").replace(".coffee", ".js");
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
