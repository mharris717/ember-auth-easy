require 'mharris_ext'
require 'coffee_short_get'

def ec(cmd)
  puts cmd
  puts `#{cmd}`
end

def templates_names(name)
  res = [name]
  res << name[1..-1] if name[0..0] == "_"

  res.map do |n|
    [n,n.gsub("_","-"),n.gsub("-","_")]
  end.flatten.uniq
end

def build_templates
  File.create "lib/templates.js",""
  Dir["src/templates/*.handlebars"].each do |f|
    base_name = File.basename(f).split(".").first
    body = File.read(f).gsub("\n"," ").gsub("'",'"')
    templates_names(base_name).each do |name|
      File.append "lib/templates.js","Em.TEMPLATES['#{name}'] = Em.Handlebars.compile('#{body}');\n\n"
    end
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
      ec "cd test_app && git reset --hard && git pull origin master && cd .. && git add test_app && git commit -m 'Updated testapp ref'"
    end
    task :test do
      run_shell_test "cd test_app && git pull origin master && npm install && rake full_install"
      if FileTest.exist?("/code/orig/ember_npm_projects")
        run_shell_test "cd test_app && rake authlink"
      end
      run_shell_test "cd test_app && npm test"
    end
  end

  task :run do
    run_shell_test "npm test"
  end
end

task :release => [:dist,'test:run'] do
  ec "git push origin master"
end

task :readme do
  ec "~/gems/github-markdown-0.5.3/bin/gfm < README.md > tmp/README.html"
end

namespace :overlay do
  task :build_inner do
    root = File.expand_path(File.dirname(__FILE__))
    app = "#{root}/test_overlay_app"
    ec "rm -rf #{app}"
    ec "/code/orig/fs_template/bin/fs_template #{root}/test_overlay #{root}/test_overlay_app"
    raise 'bad' unless $?.success?
    Dir.chdir(app) do
      ec "npm install --save-dev grunt-contrib-coffee"
      ec "npm install"
    end
  end

  task :authlink do
    res = {}
    root = File.expand_path(File.dirname(__FILE__))
    dir = "#{root}/test_overlay_app"
    
    res["#{dir}/vendor/ember-auth-easy/index.js"] = 
    "/code/orig/ember_npm_projects/ember-auth-easy/dist/ember-auth-easy.js"

    res["#{dir}/vendor/ember-auth/dist/ember-auth.js"] = 
    "/code/orig/ember-auth/dist/ember-auth.js"

    res.each do |target,source|
      `rm #{target}`
      `ln -s #{source} #{target}`
    end
  end

  task :build => [:build_inner,:authlink]
end
