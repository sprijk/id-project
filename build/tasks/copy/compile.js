var enabled, gulp, log;

gulp = require("gulp");

log = require("id-debug");

enabled = idProjectOptions.copy.enabled;

gulp.task("copy:compile", function(cb) {
  if (enabled !== true) {
    log.info("Skipping copy:compile: Disabled.");
    return cb();
  }
  gulp.src(["src/**/*", "!**/*.coffee", "!**/*.less"]).pipe(gulp.dest("build")).on("end", cb);
});
