require 'mharris_ext'
require 'coffee_short_get'

def ec(cmd)
  puts cmd
  puts `#{cmd}`
end

def build_templates
  File.create "lib/templates.js",""
  Dir["src/templates/*.handlebars"].each do |f|
    name = File.basename(f).split(".").first
    body = File.read(f).gsub("\n"," ")
    File.append "lib/templates.js","Em.TEMPLATES['#{name}'] = Em.Handlebars.compile('#{body}');\n\n"
  end
end

task :build do
  ec "rm -rf lib"
  ec "coffee -o lib/ -c src/"
  ec "coffee -o test/ -c test_coffee/"
  ec "cp -r src/*.js lib"
  ec "rm -rf lib/vendor"
  ec "cp -r vendor lib"
  build_templates

  Dir["lib/**/*.js"].each do |f|
    body = File.read(f)
    body = CoffeeParse.parse(body)
    File.create f, body
  end
end

def run_shell_test(cmd)
  puts cmd
  res = `#{cmd}`
  puts res
  raise "bad test | #{cmd} | #{res}" unless $?.success?
  res
end

task :dist => :build do
  ec "browserify lib/main.js > dist/ember-auth-easy.js"
end

namespace :test do
  namespace :app do
    task :update do
      ec "cd test_app && git pull origin master && cd .. && git add test_app && git commit -m 'Updated testapp ref'"
    end
    task :test do
      run_shell_test "cd test_app && npm install && rake full_install && npm test"
    end
  end

  task :run do
    run_shell_test "npm test"
  end
end

task :release => ['test:app:update',:dist,'test:run'] do
  ec "git push origin master"
end

