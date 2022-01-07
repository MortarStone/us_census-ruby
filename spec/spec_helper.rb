# frozen_string_literal: true

require 'simplecov'
SimpleCov.start
require 'factory_bot'
require 'bundler/setup'
require 'us_census'
require 'vcr'
require 'pry'
require 'dotenv/load'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock, :faraday
  config.default_cassette_options = { record: :once }
  config.configure_rspec_metadata!
  config.allow_http_connections_when_no_cassette = true
end

RSpec.configure do |config|
  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    FactoryBot.find_definitions
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
