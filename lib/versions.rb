# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)

require "sendgrid_template_engine/version"
require "rest-client"
require "uri"

module SendgridTemplateEngine

  class Versions

    def get(username, password, template_id, version_id)
      endpoint =
        "https://#{username}:#{password}@api.sendgrid.com/v3/templates/#{template_id}/versions/#{version_id}"
      response = JSON.parse(RestClient.get(endpoint).body)
      puts response["errors"]
      response
    end



  end

  class Version

    attr_reader :id, :template_id, :active, :name, :html_content, :plain_content, :subject, :updated_at

    def self.new_create(value)
      #value = JSON.parse(json)
      @id = value["id"]
      @template_id = value["template_id"]
      @active = value["active"]
      @name = value["name"]
      @html_content = value["html_content"]
      @plain_content = value["plain_content"]
      @subject = value["subject"]
      @updated_at = value["updated_at"]
      self
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
