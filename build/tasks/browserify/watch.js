var enabled, entryFilePath, fs, gulp, gulpLivereload, log, path, targetDirectoryPath, targetFilename, vinylSource, watchEnabled, watchify, _ref;

fs = require("fs");

path = require("path");

gulp = require("gulp");

gulpLivereload = require("gulp-livereload");

log = require("id-debug");

vinylSource = require("vinyl-source-stream");

watchify = require("watchify");

_ref = idProjectOptions.browserify, enabled = _ref.enabled, entryFilePath = _ref.entryFilePath, targetFilename = _ref.targetFilename, targetDirectoryPath = _ref.targetDirectoryPath;

watchEnabled = idProjectOptions.watch.enabled;

gulp.task("browserify:watch", ["browserify:compile", "livereload:run"], function(cb) {
  if (!(enabled === true && watchEnabled === true)) {
    log.info("Skipping browserify:watch: Disabled.");
    return cb();
  }
  fs.exists(entryFilePath, function(exists) {
    var bundler, compile;
    if (!exists) {
      log.info("Skipping browserify:watch: File `" + entryFilePath + "` not found.");
      return cb();
    }
    bundler = watchify({
      entries: [entryFilePath],
      extensions: [".js", ".json", ".jade"]
    });
    bundler.transform("jadeify");
    bundler.transform("debowerify");
    compile = function() {
      var bundle;
      bundle = bundler.bundle({
        debug: true
      });
      bundle.on("error", log.error.bind(log));
      return bundle.pipe(vinylSource(targetFilename)).pipe(gulp.dest(targetDirectoryPath)).pipe(gulpLivereload({
        auto: false
      }));
    };
    bundler.on("update", compile);
    compile();
  });
});
