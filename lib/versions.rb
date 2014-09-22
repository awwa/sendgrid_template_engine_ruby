# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)

require "sendgrid_template_engine/version"
require "rest-client"
require "uri"
require "resources"

module SendgridTemplateEngine

  class Versions < Resources

    def get(template_id, version_id)
      raise ArgumentError.new("template_id should not be nil") if template_id == nil
      raise ArgumentError.new("version_id should not be nil") if version_id == nil
      endpoint = "#{@url_base}/templates/#{template_id}/versions/#{version_id}"
      resource = RestClient::Resource.new(endpoint, @username, @password)
      body = resource.get.body
      Version.create(JSON.parse(body))
    end

    def post(template_id, version)
      raise ArgumentError.new("template_id should not be nil") if template_id == nil
      raise ArgumentError.new("version should not be nil") if version == nil
      endpoint = "#{@url_base}/templates/#{template_id}/versions"
      resource = RestClient::Resource.new(endpoint, @username, @password)
      body = resource.post(version.to_hash.to_json, :content_type => :json).body
      Version.create(JSON.parse(body))
    end

    def post_activate(template_id, version_id)
      raise ArgumentError.new("template_id should not be nil") if template_id == nil
      raise ArgumentError.new("version_id should not be nil") if version_id == nil
      endpoint = "#{@url_base}/templates/#{template_id}/versions/#{version_id}/activate"
      resource = RestClient::Resource.new(endpoint, @username, @password)
      body = resource.post(:content_type => :json).body
      Version.create(JSON.parse(body))
    end

    def patch(template_id, version_id, version)
      raise ArgumentError.new("template_id should not be nil") if template_id == nil
      raise ArgumentError.new("version_id should not be nil") if version_id == nil
      raise ArgumentError.new("version should not be nil") if version == nil
      endpoint = "#{@url_base}/templates/#{template_id}/versions/#{version_id}"
      resource = RestClient::Resource.new(endpoint, @username, @password)
      body = resource.patch(version.to_hash.to_json, :content_type => :json).body
      Version.create(JSON.parse(body))
    end

    def delete(template_id, version_id)
      raise ArgumentError.new("template_id should not be nil") if template_id == nil
      raise ArgumentError.new("version_id should not be nil") if version_id == nil
      endpoint = "#{@url_base}/templates/#{template_id}/versions/#{version_id}"
      resource = RestClient::Resource.new(endpoint, @username, @password)
      resource.delete
    end

  end

  class Version

    attr_accessor :id, :template_id, :active, :name, :html_content, :plain_content, :subject, :updated_at

    def self.create(value)
      obj = Version.new
      obj.id = value["id"]
      obj.template_id = value["template_id"]
      obj.active = value["active"]
      obj.name = value["name"]
      obj.html_content = value["html_content"]
      obj.plain_content = value["plain_content"]
      obj.subject = value["subject"]
      obj.updated_at = value["updated_at"]
      obj
    end

    def to_hash
      hash = {
        "active" => @active,
        "name" => @name,
        "html_content" => @html_content,
        "plain_content" => @plain_content,
        "subject" => @subject,
      }
      hash
    end

    def set_name(name)
      @name = name
      self
    end

    def set_subject(subject)
      @subject = subject
      self
    end

    def set_html_content(html_content)
      @html_content = html_content
      self
    end

    def set_plain_content(plain_content)
      @plain_content = plain_content
      self
    end

    def set_active(active)
      @active = active
      self
    end

  end
end
