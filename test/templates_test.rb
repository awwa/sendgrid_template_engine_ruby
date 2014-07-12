# -*- encoding: utf-8 -*-
require "json"
require "dotenv"
require "test/unit"
require "./lib/sendgrid_template_engine/version"

class TemplatesTest < Test::Unit::TestCase

  def setup
   config = Dotenv.load
   @username = ENV["SENDGRID_USERNAME"]
   @password = ENV["SENDGRID_PASSWORD"]
  end

  def test_initialize
    templates = SendgridTemplateEngine::Templates.new("user", "pass")
    assert_equal(SendgridTemplateEngine::Templates, templates.class)
  end

  def test_bad_username
    assert_raise(ArgumentError) {
      templates = SendgridTemplateEngine::Templates.new(nil, nil)
    }
  end

  def test_invalid_auth
    templates = SendgridTemplateEngine::Templates.new("user", "pass")
    assert_raise(RestClient::Unauthorized) {
      response = templates.get_all()
    }
  end

  def test_get_all
    templates = SendgridTemplateEngine::Templates.new(@username, @password)
    resp_temps = templates.get_all()
    assert_equal(true, resp_temps.length >= 0)
  end

  def test_get_template_id_nil
    templates = SendgridTemplateEngine::Templates.new(@username, @password)
    assert_raise(ArgumentError) {
      response = templates.get(nil)
    }
  end

  def test_get_template_id_not_exist
    templates = SendgridTemplateEngine::Templates.new(@username, @password)
    assert_raise(RestClient::ResourceNotFound) {
      response = templates.get("not_exist")
    }
  end

  def test_get_template_id_exist
    templates = SendgridTemplateEngine::Templates.new(@username, @password)
    # Add template
    new_template = templates.post("new_template")
    # Get template
    actual = templates.get(new_template.id)
    assert_equal(new_template.id, actual.id)
    assert_equal(new_template.name, actual.name)
    assert_equal(new_template.versions, actual.versions)
    # Delete template
    templates.delete(actual.id)
  end

  def test_post_name_nil
    templates = SendgridTemplateEngine::Templates.new(@username, @password)
    assert_raise(ArgumentError) {
      resp = templates.post(nil)
    }
  end

  def test_post_bad_request
    templates = SendgridTemplateEngine::Templates.new(@username, @password)
    expect = ""
    assert_raise(RestClient::BadRequest) {
      resp = templates.post(expect)
    }
  end

  def test_patch_id_nil
    templates = SendgridTemplateEngine::Templates.new(@username, @password)
    new_name = "new_name"
    assert_raise(ArgumentError) {
      actual = templates.patch(nil, new_name)
    }
  end

  def test_patch_name_nil
    templates = SendgridTemplateEngine::Templates.new(@username, @password)
    id = "some_id"
    assert_raise(ArgumentError) {
      actual = templates.patch(id, nil)
    }
  end

  def test_patch
    templates = SendgridTemplateEngine::Templates.new(@username, @password)
    # Add template
    new_template = templates.post("new_template")
    # Edit template
    templates.patch(new_template.id, "edit_template")
    # Get template
    actual = templates.get(new_template.id)
    assert_equal(new_template.id, actual.id)
    assert_equal("edit_template", actual.name)
    assert_equal(new_template.versions, actual.versions)
    # Delete template
    templates.delete(actual.id)
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

  def test_delete
    #-- prepare test
    templates = SendgridTemplateEngine::Templates.new(@username, @password)
    # Add template
    new_template = templates.post("new_template")
    # Delete template
    templates.delete(new_template.id)
    assert_raise(RestClient::ResourceNotFound) {
      templates.get(new_template.id)
    }
  end

end
