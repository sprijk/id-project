var applyDefaults, defaults, log, lsr;

log = require("id-debug");

lsr = require("lsr");

defaults = {};

defaults.sourceDirectoryPath = "./src";

defaults.targetDirectoryPath = "./build";

defaults.browserify = {
  enabled: true,
  entryFilePath: "" + defaults.targetDirectoryPath + "/client/js/app/app.js",
  targetFilename: "app.bundle.js",
  targetDirectoryPath: "" + defaults.targetDirectoryPath + "/client/js/app"
};

defaults.clean = {
  enabled: true
};

defaults.coffee = {
  enabled: true
};

defaults.copy = {
  enabled: true,
  sourceDirectoryPath: defaults.sourceDirectoryPath,
  targetDirectoryPath: defaults.targetDirectoryPath
};

defaults.documentation = {
  enabled: true
};

defaults.less = {
  enabled: true,
  entryFilePath: "" + defaults.sourceDirectoryPath + "/client/less/app.less",
  targetDirectoryPath: "" + defaults.targetDirectoryPath + "/client/css"
};

defaults.livereload = {
  enabled: true
};

defaults.nodemon = {
  enabled: true,
  entryFilePath: "./app.js",
  watchGlob: ["" + defaults.targetDirectoryPath + "/server/**/*.js"]
};

defaults.tests = {
  enabled: true,
  directoryPath: "./test"
};

defaults.watch = {
  enabled: true
};

applyDefaults = function(options) {
  var k, task, taskOptions, v, _results;
  _results = [];
  for (task in defaults) {
    taskOptions = defaults[task];
    _results.push((function() {
      var _results1;
      _results1 = [];
      for (k in taskOptions) {
        v = taskOptions[k];
        if (options[task] == null) {
          options[task] = {};
        }
        if (options[task][k] == null) {
          _results1.push(options[task][k] = v);
        } else {
          _results1.push(void 0);
        }
      }
      return _results1;
    })());
  }
  return _results;
};

module.exports = function(options) {
  var stat, stats, tasksDirectoryPath, _i, _len;
  if (options == null) {
    options = {};
  }
  tasksDirectoryPath = "" + __dirname + "/tasks";
  applyDefaults(options);
  global.idProjectOptions = options;
  stats = lsr.sync(tasksDirectoryPath);
  for (_i = 0, _len = stats.length; _i < _len; _i++) {
    stat = stats[_i];
    if (!stat.isDirectory()) {
      log.debug("Requiring module", stat.fullPath);
      require(stat.fullPath);
    }
  }
};
