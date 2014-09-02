var fs, gulp, gulpNodemon, log, options, path, watchNodemon;

fs = require("fs");

path = require("path");

gulp = require("gulp");

gulpNodemon = require("gulp-nodemon");

log = require("id-debug");

options = idProjectOptions;

watchNodemon = function() {
  var monitor;
  return monitor = gulpNodemon({
    script: "app.js",
    watch: ["build/server/**/*.js"]
  });
};

gulp.task("nodemon:run", ["compile"], function(cb) {
  if (options.nodemon !== true) {
    log.info("Skipping nodemon:run: Disabled.");
    return cb();
  }
  watchNodemon();
  cb();
});
