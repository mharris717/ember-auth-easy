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

def node_executable(name)
  local = "./node_modules/.bin/#{name}"
  return local if FileTest.exist?(local)
  name
end

def coffee; node_executable(:coffee); end
def browserify; node_executable(:browserify); end

task :build do
  ec "rm -rf lib"
  ec "#{coffee} -o lib/ -c src/"
  ec "#{coffee} -o test/ -c test_coffee/"
  ec "cp -r src/*.js lib" if Dir["src/**/*.js"].size > 0
  build_templates

  Dir["lib/**/*.js"].each do |f|
    body = File.read(f)
    body = CoffeeParse.parse(body)
    File.create f, body
  end
end

task :clean do
  %w(test_overlay_app test_server lib test tmp node_modules).each do |dir|
    dir = "#{eae_root_dir}/#{dir}"
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
  ec "#{browserify} lib/main.js > dist/ember-auth-easy.js"
end

task :readme do
  `mkdir tmp` unless FileTest.exist?("tmp")
  ec "~/gems/github-markdown-0.5.3/bin/gfm < README.md > tmp/README.html"
end