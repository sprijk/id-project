var Transform, browserify, enabled, entryFilePath, fs, gulp, log, targetDirectoryPath, targetFilename, vinylSource, _ref;

fs = require("fs");

browserify = require("browserify");

gulp = require("gulp");

log = require("id-debug");

vinylSource = require("vinyl-source-stream");

Transform = require("stream").Transform;

_ref = idProjectOptions.browserify, enabled = _ref.enabled, entryFilePath = _ref.entryFilePath, targetFilename = _ref.targetFilename, targetDirectoryPath = _ref.targetDirectoryPath;

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
    bundle.pipe(vinylSource(targetFilename)).pipe(gulp.dest(targetDirectoryPath)).on("end", cb);
  });
});
