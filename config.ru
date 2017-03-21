require 'net/http'

$: << 'app'

require File.expand_path('../app', __FILE__)
require File.expand_path('../twelve_factor', __FILE__)

use TwelveFactor::Logging

require 'sprockets'
require 'sass'
map '/exchange/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'public/stylesheet'
  environment.append_path 'public/assets'
  environment.css_compressor = :scss
  environment.js_compressor  = :uglify if ENV['RACK_ENV'] == 'production'
  run environment
end

run Rack::URLMap.new(
    '/'             => Sinatra::Application
)
