var changeHandler, diskWatcher, fs, gulp, log, options, path, runTests, tests;

fs = require('fs');

path = require('path');

gulp = require('gulp');

log = require('id-debug');

diskWatcher = require('../../lib/disk-watcher');

tests = require('../../lib/tests');

options = idProjectOptions;

runTests = function() {
  return tests(false, 'spec', function() {});
};

changeHandler = function(options) {
  if (!options.path.match(/\.coffee/)) {
    return;
  }
  switch (options.type) {
    case 'changed':
      return runTests();
    case 'added':
      return runTests();
  }
};

gulp.task('tests:watch', ['compile'], function(cb) {
  if (!(options.tests === true && options.watch === true)) {
    log.info("Skipping tests:watch: Disabled.");
    return cb();
  }
  diskWatcher.src().on('change', changeHandler);
  diskWatcher.test().on('change', changeHandler);
  runTests();
});
