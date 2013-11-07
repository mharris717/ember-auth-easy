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
  ec "./node_modules/.bin/coffee -o lib/ -c src/"
  ec "./node_modules/.bin/coffee -o test/ -c test_coffee/"
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

task :clean do
  %w(test_overlay_app test_server lib test tmp node_modules).each do |dir|
    dir = File.dirname(__FILE__) + "/#{dir}"
    ec "rm -rf #{dir}" if FileTest.exist?(dir)
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
  ec "./node_modules/.bin/browserify lib/main.js > dist/ember-auth-easy.js"
end

task :readme do
  ec "~/gems/github-markdown-0.5.3/bin/gfm < README.md > tmp/README.html"
end

namespace :overlay do
  def ensure_npm_global_present(name,package_name=name)
    res = `#{name} --help`
  rescue => exp
    raise "Cannot find #{name}, please run 'npm install -g #{package_name}' (possibly with sudo)."
  end

  task :ensure_npm_globals_present do
    ensure_npm_global_present "grunt","grunt-cli"
    ensure_npm_global_present "bower"
  end

  task :build_inner do
    root = File.expand_path(File.dirname(__FILE__))
    app = "#{root}/test_overlay_app"
    ec "rm -rf #{app}"
    ec "overapp #{root}/test_overlay #{root}/test_overlay_app"
    raise 'bad' unless $?.success?
    Dir.chdir(app) do
      ec "npm install"
      ec "bower install"
    end
  end

  task :authlink do
    res = {}
    root = File.expand_path(File.dirname(__FILE__))
    dir = "#{root}/test_overlay_app"
    
    res["#{dir}/vendor/ember-auth-easy/index.js"] = 
    "/code/orig/ember_npm_projects/ember-auth-easy/dist/ember-auth-easy.js"

    #res["#{dir}/vendor/ember-auth/dist/ember-auth.js"] = 
    #{}"/code/orig/ember-auth/dist/ember-auth.js"

    res.each do |target,source|
      `rm #{target}`
      `ln -s #{source} #{target}`
    end
  end

  task :copy_dist => [:dist] do
    root = File.expand_path(File.dirname(__FILE__))
    source = "#{root}/dist/ember-auth-easy.js"
    target = "#{root}/test_overlay_app/vendor/ember-auth-easy/index.js"

    ec "rm #{target}"
    ec "cp #{source} #{target}"
  end

  task :build => [:ensure_npm_globals_present,:build_inner,:copy_dist]

  task :test => [:build] do
    app = File.expand_path(File.dirname(__FILE__) + "/test_overlay_app")
    ec "cd #{app} && grunt test:ci"
  end

  task :test_inner do
    app = File.expand_path(File.dirname(__FILE__) + "/test_overlay_app")
    IO.popen("cd #{app} && grunt test:ci") do |io|
      while res = io.read(1)
        print res
      end
    end
  end
end

namespace :test_server do
  task :build do
    dir = File.expand_path(File.dirname(__FILE__) + "/test_server")
    `rm -rf #{dir}` if FileTest.exist?(dir)
    ec "overapp https://github.com/mharris717/ember_auth_rails_overlay.git #{dir}"
  end
end

