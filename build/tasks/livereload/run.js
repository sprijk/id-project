var enabled, gulp, gulpLivereload, log, net;

net = require("net");

gulp = require("gulp");

gulpLivereload = require("gulp-livereload");

log = require("id-debug");

enabled = idProjectOptions.livereload.enabled;

gulp.task("livereload:run", function(cb) {
  var connection;
  if (enabled !== true) {
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
