# -*- encoding: utf-8 -*-
require "json"
require "dotenv"
require "test/unit"
require "./lib/sendgrid_template_engine/version"

class TemplatesTest < Test::Unit::TestCase

  def setup
    Dotenv.load
    @username = ENV["SENDGRID_USERNAME"]
    @password = ENV["SENDGRID_PASSWORD"]
    @template_name = "template_test"
  end

  def test_initialize
    templates = SendgridTemplateEngine::Templates.new("user", "pass")
    assert_equal(SendgridTemplateEngine::Templates, templates.class)
  end

  def test_bad_username
    assert_raise(ArgumentError) {
      SendgridTemplateEngine::Templates.new(nil, nil)
    }
  end

  def test_invalid_auth
    templates = SendgridTemplateEngine::Templates.new("user", "pass")
    assert_raise(RestClient::Unauthorized) {
      templates.get_all()
    }
  end

  def test_get_template_id_nil
    templates = SendgridTemplateEngine::Templates.new(@username, @password)
    assert_raise(ArgumentError) {
      templates.get(nil)
    }
  end

  def test_get_template_id_not_exist
    templates = SendgridTemplateEngine::Templates.new(@username, @password)
    assert_raise(RestClient::ResourceNotFound) {
      templates.get("not_exist")
    }
  end

  def test_post_name_nil
    templates = SendgridTemplateEngine::Templates.new(@username, @password)
    assert_raise(ArgumentError) {
      templates.post(nil)
    }
  end

  def test_post_bad_request
    templates = SendgridTemplateEngine::Templates.new(@username, @password)
    expect = ""
    assert_raise(RestClient::BadRequest) {
      templates.post(expect)
    }
  end

  def test_patch_id_nil
    templates = SendgridTemplateEngine::Templates.new(@username, @password)
    new_name = "new_name"
    assert_raise(ArgumentError) {
      templates.patch(nil, new_name)
    }
  end

  def test_patch_name_nil
    templates = SendgridTemplateEngine::Templates.new(@username, @password)
    id = "some_id"
    assert_raise(ArgumentError) {
      templates.patch(id, nil)
    }
  end

  def test_delete_id_nil
    templates = SendgridTemplateEngine::Templates.new(@username, @password)
    assert_raise(ArgumentError) {
      templates.delete(nil)
    }
  end

  def test_delete_not_exist
    templates = SendgridTemplateEngine::Templates.new(@username, @password)
    assert_raise(RestClient::ResourceNotFound) {
      templates.delete("not_exist")
    }
  end

  def test_template
    templates = SendgridTemplateEngine::Templates.new(@username, @password)
    # celan up test env
    resp_temps = templates.get_all()
    assert_equal(true, resp_temps.length >= 0)
    resp_temps.each{|temp|
      if temp.name == @template_name then
        templates.delete(temp.id)
      end
    }
    # post a template
    new_template = templates.post(@template_name)
    assert_equal(@template_name, new_template.name)
    # pach the template
    templates.patch(new_template.id, "edit_template")
    # get the template
    edit_template = templates.get(new_template.id)
    assert_equal(new_template.id, edit_template.id)
    assert_equal("edit_template", edit_template.name)
    assert_equal(new_template.versions, edit_template.versions)
    # delete the template
    templates.delete(edit_template.id)
    assert_raise(RestClient::ResourceNotFound) {
      templates.get(edit_template.id)
    }
  end

end
