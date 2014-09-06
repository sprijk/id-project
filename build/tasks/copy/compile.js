var enabled, gulp, log, options;

gulp = require("gulp");

log = require("id-debug");

options = idProjectOptions.copy;

enabled = options.enabled;

gulp.task("copy:compile", function(cb) {
  if (enabled !== true) {
    log.info("Skipping copy:compile: Disabled.");
    return cb();
  }
  gulp.src(["src/**/*", "!**/*.coffee", "!**/*.less"]).pipe(gulp.dest("build")).on("end", cb);
});
