var docs, enabled, gulp, log;

gulp = require("gulp");

log = require("id-debug");

docs = require("../../lib/docs");

enabled = idProjectOptions.documentation.enabled;

gulp.task("documentation:compile", function(cb) {
  if (enabled !== true) {
    log.info("Skipping documentation:compile: Disabled.");
    return cb();
  }
  docs(false, cb);
});
