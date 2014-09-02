var cp, fs, log, path, pathToMocha, pathToTestsDirectory, tests;

fs = require("fs");

path = require("path");

cp = require("child_process");

log = require("id-debug");

pathToMocha = path.resolve("" + __dirname + "/../../node_modules/.bin/mocha");

pathToTestsDirectory = path.resolve("" + __dirname + "/../../test");

tests = function(exit, reporter, cb) {
  return fs.exists(pathToTestsDirectory, function(exists) {
    var childProcess;
    if (!exists) {
      log.info("Skipping mocha: Directory `" + pathToTestsDirectory + "` not found.");
      return cb();
    }
    childProcess = cp.spawn(pathToMocha, ["--recursive", "--compilers", "coffee:coffee-script/register", "--reporter", reporter, "test"]);
    childProcess.stdout.on("data", function(chunk) {
      return process.stdout.write(chunk);
    });
    childProcess.stderr.on("data", function(chunk) {
      return process.stderr.write(chunk);
    });
    return childProcess.once("close", function() {
      if (exit) {
        return process.exit();
      } else {
        return cb();
      }
    });
  });
};

module.exports = tests;
