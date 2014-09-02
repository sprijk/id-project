var Transform, browserify, entryFilePath, fs, gulp, log, options, targetDirectory, vinylSource;

fs = require("fs");

browserify = require("browserify");

gulp = require("gulp");

log = require("id-debug");

vinylSource = require("vinyl-source-stream");

Transform = require("stream").Transform;

entryFilePath = "./build/client/js/app/index.js";

targetDirectory = "./build/client/js/app";

options = idProjectOptions;

gulp.task("browserify:compile", ["coffee:compile", "copy:compile"], function(cb) {
  if (options.browserify !== true) {
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
    bundle.pipe(vinylSource("app.bundle.js")).pipe(gulp.dest(targetDirectory)).on("end", cb);
  });
});
