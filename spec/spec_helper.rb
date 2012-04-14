ENV['RACK_ENV'] = 'test'

# Path to your real ruby(sinatra) application
require File.join(File.dirname(__FILE__), '..', 'main.rb')
require 'rack/test'
require 'rspec'
require 'factory_girl'
require 'capybara'
require 'capybara/dsl'
require 'database_cleaner'

# Use the following mixin to wire up rack/test and sinatra
module RSpecMixin
  include Rack::Test::Methods
  Capybara.app = Sinatra::Application
  require_relative 'factories'
  def app() Sinatra::Application end
end

RSpec.configure do |c|
  c.include RSpecMixin
  c.include FactoryGirl::Syntax::Methods
  c.include Capybara

  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.filter_run :focus => true
  c.run_all_when_everything_filtered = true

  c.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  c.before(:each) do
    DatabaseCleaner.start
  end

  c.after(:each) do
    DatabaseCleaner.clean
  end
end

