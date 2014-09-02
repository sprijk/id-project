var gulp, gulpCoffee, log, options;

gulp = require("gulp");

gulpCoffee = require("gulp-coffee");

log = require("id-debug");

options = idProjectOptions;

gulp.task("coffee:compile", function(cb) {
  var coffeeCompiler;
  if (options.coffee !== true) {
    log.info("Skipping coffee:compile: Disabled.");
    return cb();
  }
  coffeeCompiler = gulpCoffee({
    bare: true
  });
  coffeeCompiler.on("error", log.error.bind(log));
  gulp.src("src/**/*.coffee").pipe(coffeeCompiler).pipe(gulp.dest("build")).on("end", cb);
});
