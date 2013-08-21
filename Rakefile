def ec(cmd)
  puts cmd
  puts `#{cmd}`
end

task :build do
  ec "coffee -o lib/ -c src/"
  ec "coffee -o test/ -c test_coffee/"
  ec "rm -rf lib/vendor"
  ec "cp -r vendor lib"
end

task :test => :build do
  ec "npm test"
end
