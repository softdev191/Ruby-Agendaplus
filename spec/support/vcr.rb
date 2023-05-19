# frozen_string_literal: true

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.ignore_hosts '127.0.0.1', 'localhost', 'elasticsearch'
  config.hook_into :webmock
end
