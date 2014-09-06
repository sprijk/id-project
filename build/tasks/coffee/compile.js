var enabled, gulp, gulpCoffee, log, sourceDirectoryPath, targetDirectoryPath, _ref;

gulp = require("gulp");

gulpCoffee = require("gulp-coffee");

log = require("id-debug");

_ref = idProjectOptions.coffee, enabled = _ref.enabled, sourceDirectoryPath = _ref.sourceDirectoryPath, targetDirectoryPath = _ref.targetDirectoryPath;

gulp.task("coffee:compile", function(cb) {
  var coffeeCompiler;
  if (enabled !== true) {
    log.info("Skipping coffee:compile: Disabled.");
    return cb();
  }
  coffeeCompiler = gulpCoffee({
    bare: true
  });
  coffeeCompiler.on("error", log.error.bind(log));
  gulp.src("" + sourceDirectoryPath + "/**/*.coffee").pipe(coffeeCompiler).pipe(gulp.dest(targetDirectoryPath)).on("end", cb);
});
