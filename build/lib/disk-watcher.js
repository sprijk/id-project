var gulp, srcWatch, testWatch;

gulp = require('gulp');

srcWatch = null;

testWatch = null;

module.exports = {
  src: function() {
    srcWatch || (srcWatch = gulp.watch('src/**/*', {
      read: false
    }));
    return srcWatch;
  },
  test: function() {
    testWatch || (testWatch = gulp.watch('test/**/*', {
      read: false
    }));
    return testWatch;
  }
};
