# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)

require "sendgrid_template_engine/version"
require "rest-client"
require "resources"
require "versions"

module SendgridTemplateEngine

  class Templates < Resources

    def get_all
      endpoint = "#{@url_base}/templates"
      resource = RestClient::Resource.new(endpoint, @username, @password)
      body = resource.get.body
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
      resource = RestClient::Resource.new(endpoint, @username, @password)
      body = resource.get.body
      Template.create(JSON.parse(body))
    end

    def post(name)
      raise ArgumentError.new("name should not be nil") if name == nil
      endpoint = "#{@url_base}/templates"
      resource = RestClient::Resource.new(endpoint, @username, @password)
      params = Hash.new
      params["name"] = name
      body = resource.post(params.to_json, :content_type => :json).body
      Template.create(JSON.parse(body))
    end

    def patch(template_id, name)
      raise ArgumentError.new("template_id should not be nil") if template_id == nil
      raise ArgumentError.new("name should not be nil") if name == nil
      endpoint = "#{@url_base}/templates/#{template_id}"
      resource = RestClient::Resource.new(endpoint, @username, @password)
      params = Hash.new
      params["name"] = name
      body = resource.patch(params.to_json, :content_type => :json).body
      Template.create(JSON.parse(body))
    end

    def delete(template_id)
      raise ArgumentError.new("template_id should not be nil") if template_id == nil
      endpoint = "#{@url_base}/templates/#{template_id}"
      resource = RestClient::Resource.new(endpoint, @username, @password)
      resource.delete
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
