def ec_popen(cmd)
  puts cmd
  IO.popen(cmd) do |io|
    while res = io.read
      print res
    end
  end
end

namespace :test_server do
  task :build do
    dir = "#{eae_root_dir}/test_server"
    `rm -rf #{dir}` if FileTest.exist?(dir)
    ec "overapp https://github.com/mharris717/ember_auth_rails_overlay.git #{dir}"
  end

  task :run2 do
    ec_popen("cd test_server && rails server -p 5901")

    20.times do
      puts "AFTER #{Time.now}"
      sleep(1)
    end
  end

  task :run do
    pid = fork do
      exec "cd test_server && rails server -p 5902"
    end

    puts "PID: child: #{pid} me: #{Process.pid}"
    require 'mharris_ext'
    File.create "pids.txt","PID: child: #{pid} me: #{Process.pid}"

    sleep(5)

    system "cd test_overlay_app && grunt test:ci"

    puts "PID: child: #{pid} me: #{Process.pid}"
    puts `ps -ax | grep ruby`

    ec "pkill -signal kill -P #{pid}"

  end
end