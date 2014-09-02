var docs, gulp, log, options;

gulp = require("gulp");

log = require("id-debug");

docs = require("../../lib/docs");

options = idProjectOptions;

gulp.task("documentation:compile", function(cb) {
  if (options.documentation !== true) {
    log.info("Skipping documentation:compile: Disabled.");
    return cb();
  }
  docs(false, cb);
});
