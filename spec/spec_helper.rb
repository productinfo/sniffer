# frozen_string_literal: true

require "bundler/setup"
require "sniffer"
require "pry-byebug"
Dir[File.expand_path(File.join(File.dirname(__FILE__), 'support', '**', '*.rb'))].each { |f| require f }

when_enabled = { enabled: ->(v) { v } }

@server_thread = Thread.new do
  FakeWeb::App.run!
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    Sniffer.reset!
  end

  config.before(:each, when_enabled) do
    Sniffer.reset!
    Sniffer.enable!
  end
end