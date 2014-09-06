var docs, enabled, gulp, log, options;

gulp = require("gulp");

log = require("id-debug");

docs = require("../../lib/docs");

options = idProjectOptions.documentation;

enabled = options.enabled;

gulp.task("documentation:compile", function(cb) {
  if (enabled !== true) {
    log.info("Skipping documentation:compile: Disabled.");
    return cb();
  }
  docs(false, cb);
});
