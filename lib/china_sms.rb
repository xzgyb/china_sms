# encoding: utf-8
require "china_sms/version"
require 'net/http'

module ChinaSMS
  extend self

  attr_reader :username, :password

  def use(service, options)
    require "china_sms/service/#{service}"
    @service = ChinaSMS::Service.const_get("#{service.to_s.capitalize}")
    @service.const_set("URL", options[:base_uri]) if options[:base_uri]
    @username = options[:username]
    @password = options[:password]
  end

  def to(receiver, content, options = {})
    options = default_options.merge options
    @service.to receiver, content, options if @service
  end

  def get(options = {})
    options = default_options.merge options
    @service.get options if @service
  end

  def clear
    @service = @username = @password = nil
  end

  private

  def default_options
    {
      username:  @username,
      password:  @password
    }
  end

end
