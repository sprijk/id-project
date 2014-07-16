var diskWatcher, entryFilePath, fs, gulp, gulpLess, gulpLivereload, log, options, path;

fs = require('fs');

path = require('path');

gulp = require('gulp');

gulpLess = require('gulp-less');

gulpLivereload = require('gulp-livereload');

log = require('id-debug');

diskWatcher = require('../../lib/disk-watcher');

entryFilePath = 'src/client/less/app.less';

options = idProjectOptions;

gulp.task('less:watch', ['less:compile', 'livereload:run'], function(cb) {
  if (!(options.less === true && options.watch === true)) {
    log.info("Skipping less:watch: Disabled.");
    return cb();
  }
  fs.exists(entryFilePath, function(exists) {
    var compilePath, removePath;
    if (!exists) {
      log.info("Skipping less:compile: File `" + entryFilePath + "` not found.");
      return cb();
    }
    compilePath = function(sourcePath) {
      var buildDirectory, sourceDirectory;
      sourceDirectory = path.dirname(sourcePath);
      buildDirectory = sourceDirectory.replace('src', 'build').replace('.less', '.css').replace('/less', '/css');
      return gulp.src(sourcePath).pipe(gulpLess()).pipe(gulp.dest(buildDirectory)).pipe(gulpLivereload({
        auto: false
      }));
    };
    removePath = function(sourcePath) {
      var targetPath;
      targetPath = sourcePath.replace('src', 'build').replace('.less', '.css').replace('/less', '/css');
      return fs.unlink(targetPath, function(error) {
        if (error) {
          return log.error(error);
        }
      });
    };
    return diskWatcher.src().on('change', function(options) {
      if (!options.path.match(/\.less/)) {
        return;
      }
      switch (options.type) {
        case 'changed':
          return compilePath('./src/client/less/app.less');
        case 'added':
          return compilePath('./src/client/less/app.less');
        case 'deleted':
          return removePath(options.path);
      }
    });
  });
});
