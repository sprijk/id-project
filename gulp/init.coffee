require "./tasks/#{task}" for task in (require 'fs').readdirSync "#{__dirname}/tasks" when task.match /\.coffee$/
