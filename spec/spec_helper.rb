# encoding: utf-8
require 'rubygems'
require 'bundler/setup'
require 'rspec/its'

require 'webmock/rspec'
require 'china_sms'

#WebMock.allow_net_connect!
RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.syntax = [:expect, :should]
  end
end
