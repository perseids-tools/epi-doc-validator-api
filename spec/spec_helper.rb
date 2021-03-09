require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path('../app.rb', __dir__)

module RSpecMixin
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def fixture(file)
    File.read(File.expand_path(File.join('fixtures/files/', file), __dir__))
  end
end

RSpec.configure do |config|
  config.include RSpecMixin

  config.example_status_persistence_file_path = '.rspec_status'

  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
