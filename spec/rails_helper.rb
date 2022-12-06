# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../spec/dummy/config/environment"
require "minitest"
require "rails-dom-testing"
require "rspec/rails/adapters"

RSpec.configure do |config|
  config.include Rails::Dom::Testing::Assertions
  config.include RSpec::Rails::MinitestAssertionAdapter
  config.order = "random"
end
