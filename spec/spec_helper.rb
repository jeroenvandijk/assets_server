ENV["RAILS_ENV"] = "test"
require 'rubygems'
require 'spec'
require 'sass'
require 'sass/plugin'

$: << File.dirname(__FILE__) + '/../lib'

require 'assets_server'


Spec::Runner.configure do |config|
  config.mock_with :mocha
end

RAILS_ROOT = File.expand_path(File.dirname(__FILE__) + '/../' )