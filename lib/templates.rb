# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)

require "sendgrid_template_engine/version"
require "rest-client"
require "uri"
require "versions"

module SendgridTemplateEngine

  class Templates

    def initialize(username, password)
      raise ArgumentError.new("username should not be nil") if username == nil
      raise ArgumentError.new("password should not be nil") if password == nil
      @url_base = "https://#{username}:#{password}@api.sendgrid.com/v3"
    end

    def get_all
      endpoint = "#{@url_base}/templates"
      body = RestClient.get(endpoint).body
      response = JSON.parse(body)
      temps = []
      response["templates"].each{|template|
        temp = Template.create(template)
        temps.push(temp)
      } if response["templates"] != nil
      temps
    end

    def get(template_id)
      raise ArgumentError.new("template_id should not be nil") if template_id == nil
      endpoint = "#{@url_base}/templates/#{template_id}"
      body = RestClient.get(endpoint).body
      Template.create(JSON.parse(body))
    end

    def post(name)
      raise ArgumentError.new("name should not be nil") if name == nil
      endpoint = "#{@url_base}/templates"
      params = Hash.new
      params['name'] = name
      body = RestClient.post(endpoint, params.to_json, :content_type => :json).body
      Template.create(JSON.parse(body))
    end

    def patch(template_id, name)
      raise ArgumentError.new("template_id should not be nil") if template_id == nil
      raise ArgumentError.new("name should not be nil") if name == nil
      endpoint = "#{@url_base}/templates/#{template_id}"
      params = Hash.new
      params['name'] = name
      body = RestClient.patch(endpoint, params.to_json, :content_type => :json).body
      Template.create(JSON.parse(body))
    end

    def delete(template_id)
      raise ArgumentError.new("template_id should not be nil") if template_id == nil
      endpoint = "#{@url_base}/templates/#{template_id}"
      RestClient.delete(endpoint)
    end

  end

  class Template

    attr_accessor :id, :name, :versions

    def self.create(value)
      obj = Template.new
      obj.id = value["id"]
      obj.name = value["name"]
      obj.versions = []
      value["versions"].each{|version|
        ver = Version.create(version)
        obj.versions.push(ver)
      }
      obj
    end

  end
end
