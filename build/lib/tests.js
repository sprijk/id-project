var cp, path, pathToMocha, tests;

path = require("path");

cp = require("child_process");

pathToMocha = path.resolve("" + __dirname + "/../../node_modules/.bin/mocha");

tests = function(exit, reporter, cb) {
  var childProcess;
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
};

module.exports = tests;
