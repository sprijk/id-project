var cp, tests;

cp = require('child_process');

tests = function(exit, reporter, cb) {
  var childProcess;
  childProcess = cp.spawn('mocha', ['--recursive', '--compilers', 'coffee:coffee-script/register', '--reporter', reporter, 'test']);
  childProcess.stdout.on('data', function(chunk) {
    return process.stdout.write(chunk);
  });
  childProcess.stderr.on('data', function(chunk) {
    return process.stderr.write(chunk);
  });
  return childProcess.once('close', function() {
    if (exit) {
      return process.exit();
    } else {
      return cb();
    }
  });
};

module.exports = tests;
