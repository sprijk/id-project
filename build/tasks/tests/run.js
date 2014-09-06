var directoryPath, enabled, gulp, log, options, tests, _ref;

gulp = require("gulp");

log = require("id-debug");

tests = require("../../lib/tests");

options = idProjectOptions;

_ref = idProjectOptions.less, enabled = _ref.enabled, directoryPath = _ref.directoryPath;

gulp.task("tests:run", ["compile"], function(cb) {
  if (enabled !== true) {
    log.info("Skipping tests:run: Disabled.");
    return cb();
  }
  tests(directoryPath, true, "spec", cb);
});
