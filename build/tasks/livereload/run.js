var gulp, gulpLivereload, log, net, options;

net = require("net");

gulp = require("gulp");

gulpLivereload = require("gulp-livereload");

log = require("id-debug");

options = idProjectOptions;

gulp.task("livereload:run", function(cb) {
  var connection;
  if (options.livereload !== true) {
    log.info("Skipping livereload:run: Disabled.");
    return cb();
  }
  connection = net.connect(35729);
  connection.on("connect", function() {
    log.info("Livereload server already running.");
    return cb();
  });
  connection.on("error", function() {
    log.info("Livereload server not yet running. Starting one.");
    gulpLivereload.listen();
    return cb();
  });
});
