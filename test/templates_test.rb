# -*- encoding: utf-8 -*-
require "json"
require "dotenv"
require "test/unit"
require "./lib/sendgrid_template_engine/version"

class TemplateTest < Test::Unit::TestCase

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
    templates = SendgridTemplateEngine::Templates.new(@username, @password, )
    assert_raise(ArgumentError) {
      response = templates.get(nil)
    }
  end

  def test_get_template_id_not_exist
    templates = SendgridTemplateEngine::Templates.new(@username, @password, )
    assert_raise(RestClient::ResourceNotFound) {
      response = templates.get("not_exist")
    }
  end

  def test_get_template_id_exist
    templates = SendgridTemplateEngine::Templates.new(@username, @password)
    resp_temps_all = templates.get_all()
    if resp_temps_all.length == 0 then
      templates.post("new_template")
    end
    resp_temps_all = templates.get_all()
    assert_equal(true, resp_temps_all.length > 0)
    expect = resp_temps_all[0]
    actual = templates.get(expect.id)
    assert_equal(expect.id, actual.id)
    assert_equal(expect.name, actual.name)
    assert_equal(expect.versions, actual.versions)
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

  def test_post
    #-- prepare test
    templates = SendgridTemplateEngine::Templates.new(@username, @password)
    resp_temps_all = templates.get_all()
    new_name = "new_template"
    if resp_temps_all.length > 0 then
      temp = templates.get(resp_temps_all[0].id).name
      new_name = temp + "1"
    end
    #-- prepare test
    actual = templates.post(new_name)
    assert_equal(true, actual.id.length > 0)
    assert_equal(new_name, actual.name)
    assert_equal(true, actual.versions.length == 0)
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
    #-- prepare test
    templates = SendgridTemplateEngine::Templates.new(@username, @password)
    resp_temps_all = templates.get_all()
    new_name = "new_template"
    if resp_temps_all.length > 0 then
      temp = templates.get(resp_temps_all[0].id).name
      new_name = temp + "1"
    end
    expected = templates.post(new_name)
    #-- prepare test
    new_name += "2"
    actual = templates.patch(expected.id, new_name)
    assert_equal(expected.id, actual.id)
    assert_equal(new_name, actual.name)
    assert_equal(expected.versions, actual.versions)
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
    resp_temps_all = templates.get_all()
    new_name = "new_template"
    if resp_temps_all.length > 0 then
      temp = templates.get(resp_temps_all[0].id).name
      new_name = temp + "1"
    end
    expected = templates.post(new_name)
    #-- prepare test
    templates.delete(expected.id)
    assert_raise(RestClient::ResourceNotFound) {
      templates.get(expected.id)
    }
  end

end
