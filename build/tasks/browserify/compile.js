var Transform, browserify, enabled, entryFilePath, fs, gulp, gulpTap, log, options, path, targetDirectoryPath, targetFilename, vinylSource;

fs = require("fs");

path = require("path");

browserify = require("browserify");

gulp = require("gulp");

gulpTap = require("gulp-tap");

log = require("id-debug");

vinylSource = require("vinyl-source-stream");

Transform = require("stream").Transform;

options = idProjectOptions.browserify;

enabled = options.enabled;

entryFilePath = path.resolve(options.entryFilePath);

targetDirectoryPath = path.resolve(options.targetDirectoryPath);

targetFilename = options.targetFilename;

gulp.task("browserify:compile", ["coffee:compile", "copy:compile"], function(cb) {
  if (enabled !== true) {
    log.info("Skipping browserify:compile: Disabled.");
    return cb();
  }
  fs.exists(entryFilePath, function(exists) {
    var bundle, bundler;
    if (!exists) {
      log.info("Skipping browserify:compile: File `" + entryFilePath + "` not found.");
      return cb();
    }
    bundler = browserify({
      entries: [entryFilePath],
      extensions: [".js", ".json", ".jade"]
    });
    bundler.transform("jadeify");
    bundler.transform("debowerify");
    bundle = bundler.bundle({
      debug: true
    });
    bundle.on("error", log.error.bind(log));
    bundle.pipe(vinylSource(targetFilename)).pipe(gulpTap(function(file) {
      log.debug("browserify:compile: Compiling `" + file.path + "` into `" + targetDirectoryPath + "`.");
    })).pipe(gulp.dest(targetDirectoryPath)).on("end", cb);
  });
});
