ENV['RACK_ENV'] = 'test'

# Path to your real ruby(sinatra) application
require File.join(File.dirname(__FILE__), '..', 'main.rb')
require 'rack/test'
require 'rspec'

# Use the following mixin to wire up rack/test and sinatra
module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure do |c|
  c.include RSpecMixin
end

#set test environment

#set :environment, :test
#set :run, false
#set :raise_errors, true
#set :logging, false

# For testing models
# reset the database before each test to make sure our tests don't influence one another
#Rspec.configure do |config|
  #config.before(:each) { DataMapper.auto_migrate! }
#end
