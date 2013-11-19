require 'mharris_ext'
require 'coffee_short_get'
require 'npm_overapp'

NpmOverapp.server_base_overlay = "https://github.com/mharris717/ember_auth_rails_overlay.git"

%w(build).each do |f|
  load File.dirname(__FILE__) + "/tasks/#{f}.rb"
end

