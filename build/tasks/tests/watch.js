var changeHandler, directoryPath, diskWatcher, enabled, fs, gulp, log, path, runTests, tests, watchEnabled, _ref;

fs = require("fs");

path = require("path");

gulp = require("gulp");

log = require("id-debug");

diskWatcher = require("../../lib/disk-watcher");

tests = require("../../lib/tests");

_ref = idProjectOptions.tests, enabled = _ref.enabled, directoryPath = _ref.directoryPath;

watchEnabled = idProjectOptions.watch.enabled;

runTests = function() {
  return tests(directoryPath, false, "progress", function() {});
};

changeHandler = function(options) {
  if (!options.path.match(/\.coffee/)) {
    return;
  }
  return runTests();
};

gulp.task("tests:watch", ["compile"], function(cb) {
  if (!(enabled === true && watchEnabled === true)) {
    log.info("Skipping tests:watch: Disabled.");
    return cb();
  }
  diskWatcher.src().on("change", changeHandler);
  diskWatcher.test().on("change", changeHandler);
  runTests();
});
