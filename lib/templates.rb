# -*- encoding: utf-8 -*-
$:.unshift File.dirname(__FILE__)

require "sendgrid_template_engine/version"
require "rest-client"
require "uri"
require "versions"

module SendgridTemplateEngine
  # Your code goes here...
  class Templates

    # TODO 関数にコードブロックを渡すにはどうすればよいか？
    def get_all(username, password)

      endpoint = "https://#{username}:#{password}@api.sendgrid.com/v3/templates"
      body = RestClient.get(endpoint).body
      response = JSON.parse(body)

      if response["errors"] then
        raise response["errors"][0]
      else
        temps = []
        response["templates"].each{|template|
          temp = Template.create(template)
          temps.push(temp)
        } if response["templates"] != nil
        temps
      end
    end

    def get(username, password, template_id)

      # TODO template_id nilチェック
      endpoint = "https://#{username}:#{password}@api.sendgrid.com/v3/templates/#{template_id}"
      body = RestClient.get(endpoint).body
      response = JSON.parse(body)

      if response["errors"] then
        raise response["errors"][0]
      else
        Template.create(response)
      end
    end

    def post(username, password, name)
      endpoint = "https://#{username}:#{password}@api.sendgrid.com/v3/templates"
      params = Hash.new
      params['name'] = name
      b = RestClient.post endpoint, params.to_json, :content_type => :json
      response = JSON.parse(b.body)

      if response["errors"] then    # TODO 正常応答の場合、errorsは来ないと思われる。例外の時に処理する要修正
        raise response["errors"][0]
      else
        Template.create(response)
      end
    end

    def patch(username, password, template_id, name)
      endpoint = "https://#{username}:#{password}@api.sendgrid.com/v3/templates/#{template_id}"
      params = Hash.new
      params['name'] = name
      body = RestClient.patch(endpoint, params.to_json, :content_type => :json).body
      response = JSON.parse(body)

      if response["errors"] then
        raise response["errors"][0]
      else
        Template.create(response)
      end
    end

    def delete(username, password, template_id)
      endpoint = "https://#{username}:#{password}@api.sendgrid.com/v3/templates/#{template_id}"
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
        ver = Version.new_create(version)
        obj.versions.push(ver)
      }
      obj
    end
  end
end
