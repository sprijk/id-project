var enabled, gulp, gulpTap, log, options, path, sourceDirectoryPath, targetDirectoryPath;

path = require("path");

gulp = require("gulp");

gulpTap = require("gulp-tap");

log = require("id-debug");

options = idProjectOptions.copy;

enabled = options.enabled;

sourceDirectoryPath = path.resolve(options.sourceDirectoryPath);

targetDirectoryPath = path.resolve(options.targetDirectoryPath);

gulp.task("copy:compile", function(cb) {
  if (enabled !== true) {
    log.info("Skipping copy:compile: Disabled.");
    return cb();
  }
  log.debug("[copy:compile] Source directory path: `" + sourceDirectoryPath + "`.");
  log.debug("[copy:compile] Target directory path: `" + targetDirectoryPath + "`.");
  gulp.src(["" + sourceDirectoryPath + "/**/*", "!**/*.coffee", "!**/*.less"]).pipe(gulpTap(function(file) {
    log.debug("[copy:compile] Copying `" + file.path + "`.");
  })).pipe(gulp.dest(targetDirectoryPath)).on("end", cb);
});
