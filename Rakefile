require 'mharris_ext'
require 'coffee_short_get'

def ec(cmd,ops={})
  puts cmd unless ops[:silent]
  res = nil
  if has_bundler?
    Bundler.with_clean_env do
      res = `#{cmd}`
    end
  else
    res = `#{cmd}`
  end

  raise "bad cmd #{$?.to_i} #{cmd} #{res}" unless $?.to_i == 0
  puts res unless ops[:silent]
  res
end


def eae_root_dir
  File.expand_path(File.dirname(__FILE__))
end

%w(build overlay test_server).each do |f|
  load File.dirname(__FILE__) + "/tasks/#{f}.rb"
end