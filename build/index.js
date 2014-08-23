var defaultOptions, log, lsr;

log = require('id-debug');

lsr = require('lsr');

defaultOptions = {
  browserify: true,
  clean: true,
  coffee: true,
  copy: true,
  documentation: true,
  less: true,
  livereload: true,
  nodemon: true,
  tests: true,
  watch: true
};

module.exports = function(options) {
  var k, stat, stats, tasksDirectoryPath, v, _i, _len;
  if (options == null) {
    options = {};
  }
  tasksDirectoryPath = "" + __dirname + "/tasks";
  for (k in defaultOptions) {
    v = defaultOptions[k];
    if (options[k] === void 0) {
      options[k] = v;
    }
  }
  global.idProjectOptions = options;
  stats = lsr.sync(tasksDirectoryPath);
  for (_i = 0, _len = stats.length; _i < _len; _i++) {
    stat = stats[_i];
    if (!stat.isDirectory()) {
      log.debug('Requiring module', stat.fullPath);
      require(stat.fullPath);
    }
  }
};
