var gulp, log, options, tests;

gulp = require("gulp");

log = require("id-debug");

tests = require("../../lib/tests");

options = idProjectOptions;

gulp.task("tests:run", ["compile"], function(cb) {
  if (options.tests !== true) {
    log.info("Skipping tests:run: Disabled.");
    return cb();
  }
  tests(true, "spec", cb);
});
