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
    root = eae_root_dir
    app = "#{root}/test_overlay_app"
    ec "rm -rf #{app}" if FileTest.exist?(app)
    ec "mkdir #{app}"
    ec "overapp #{root}/test_overlay #{root}/test_overlay_app"
    raise 'bad' unless $?.success?
    Dir.chdir(app) do
      ec "npm install"
      ec "bower install"
    end
  end

  task :authlink do
    res = {}
    root = eae_root_dir
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
    root = eae_root_dir
    source = "#{root}/dist/ember-auth-easy.js"
    target = "#{root}/test_overlay_app/vendor/ember-auth-easy/index.js"

    ec "rm #{target}"
    ec "cp #{source} #{target}"
  end

  task :build => [:ensure_npm_globals_present,:build_inner,:copy_dist]

  def run_test
    app = "#{eae_root_dir}/test_overlay_app"
    ec "cd #{app} && grunt test:ci"
  end

  task :test => [:build] do
    run_test
  end

  task :test_both => [:build] do
    run_test
    set_overlay_mode "server"
    run_test
  end

  def set_overlay_mode(mode)
    other = (mode == 'isolated') ? 'server' : 'isolated'
    file = "#{eae_root_dir}/test_overlay_app/tests/pre_app.js"
    body = File.read(file)
    body = body.gsub "testingMode(\"#{other}\")","testingMode(\"#{mode}\")"
    File.create file, body
  end

  task :make_server_mode do
    set_overlay_mode "server"
  end

  task :test_inner do
    app = "#{eae_root_dir}/test_overlay_app"
    IO.popen("cd #{app} && grunt test:ci") do |io|
      while res = io.read(1)
        print res
      end
    end
  end
end