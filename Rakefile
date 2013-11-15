require 'mharris_ext'
require 'coffee_short_get'

def eae_root_dir
  File.expand_path(File.dirname(__FILE__))
end

%w(build overlay test_server).each do |f|
  load File.dirname(__FILE__) + "/tasks/#{f}.rb"
end