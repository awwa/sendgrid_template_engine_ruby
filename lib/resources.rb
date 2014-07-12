# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)

require "sendgrid_template_engine/version"
require "rest-client"
require "uri"

module SendgridTemplateEngine

  class Resources

    def initialize(username, password)
      raise ArgumentError.new("username should not be nil") if username == nil
      raise ArgumentError.new("password should not be nil") if password == nil
      @url_base = "https://#{username}:#{password}@api.sendgrid.com/v3"
    end
    
  end

end
