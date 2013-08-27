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

task :test => :build do
  exec "npm test"
end

task :dist => :build do
  ec "browserify lib/main.js > dist/ember-auth-easy.js"
end


