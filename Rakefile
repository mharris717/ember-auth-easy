def ec(cmd)
  puts cmd
  puts `#{cmd}`
end

task :build do
  ec "coffee -o lib/ -c src/"
  ec "coffee -o test/ -c test_coffee/"
end

task :test => :build do
  ec "npm test"
end
