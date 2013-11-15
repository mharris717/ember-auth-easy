namespace :test_server do
  def overapp
    locals = ["/code/orig/overapp/bin/overapp"]
    locals.find { |x| FileTest.exist?(x) } || "overapp"
  end

  def test_server_dir
    File.expand_path(File.dirname(__FILE__) + "/../test_server")
  end

  task :build do
    ec "rm -rf #{test_server_dir}" if FileTest.exist?(test_server_dir)
    ec "mkdir #{test_server_dir}"
    ec "#{overapp} https://github.com/mharris717/ember_auth_rails_overlay.git #{test_server_dir}"
  end

  task :db do
    ec "cd #{test_server_dir} && bundle install && rake ember_auth_rails_engine:install:migrations && rake db:migrate db:seed"
  end

  task :setup => [:build,:db]

  def pid_status(desc)
    res = [desc]
    res << "This: #{Process.pid}"
    res << "Forked: #{$forked_pid}"
    res += server_ps_lines
    str = res.join("\n")
    puts str
    File.append "pids.txt",str+"\n\n"
  end

  def server_ps_lines
    `ps -ax | grep #{port}`.split("\n").reject { |x| x =~ /grep/ }
  end

  def server_pids
    server_ps_lines.map { |x| x.split(/\s/).first }
  end

  def port
    5901
  end

  task :start_in_background do
    fork do
      ec "cd #{test_server_dir} && rails server -p #{port}"
    end
    sleep(5)
  end

  task :start do
    ec "cd #{test_server_dir} && rails server -p #{port}"
  end

  def kill_strays
    server_pids.each do |pid|
      ec "kill -s int #{pid}"
    end
  end

  task :kill_strays do
    kill_strays
  end
end