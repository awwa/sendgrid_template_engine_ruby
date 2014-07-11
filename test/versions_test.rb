# -*- encoding: utf-8 -*-
require "json"
require "dotenv"
require "test/unit"
require "./lib/sendgrid_template_engine/version"

class VersionsTest < Test::Unit::TestCase

  def setup
   config = Dotenv.load
   @username = ENV["SENDGRID_USERNAME"]
   @password = ENV["SENDGRID_PASSWORD"]
  end

  def test_initialize
    versions = SendgridTemplateEngine::Versions.new("user", "pass")
    assert_equal(SendgridTemplateEngine::Versions, versions.class)
  end

  def test_bad_username
    assert_raise(ArgumentError) {
      versions = SendgridTemplateEngine::Versions.new(nil, nil)
    }
  end

  def test_invalid_auth
    versions = SendgridTemplateEngine::Versions.new("user", "pass")
    assert_raise(RestClient::Unauthorized) {
      response = versions.get("template_id", "version_id")
    }
  end

  def test_get_template_id_nil
    versions = SendgridTemplateEngine::Versions.new(@username, @password)
    assert_raise(ArgumentError) {
      response = versions.get(nil, "version_id")
    }
  end

  def test_get_version_id_nil
    versions = SendgridTemplateEngine::Versions.new(@username, @password)
    assert_raise(ArgumentError) {
      response = versions.get("template_id", nil)
    }
  end

  def test_get_not_exist
    versions = SendgridTemplateEngine::Versions.new(@username, @password)
    assert_raise(RestClient::ResourceNotFound) {
      response = versions.get("not_exist", "not_exist")
    }
  end

  # def test_get
  #   templates = SendgridTemplateEngine::Templates.new(@username, @password)
  #   resp_temps_all = templates.get_all()
  #   if resp_temps_all.length == 0 then
  #     templates.post("new_template")
  #   end
  #   resp_temps_all = templates.get_all()
  #   template = resp_temps_all[0]
  #
  #   new_version = SendgridTemplateEngine::Version.new()
  #   new_version.set_name("new_version_name")
  #   new_version.set_subject("new_version_subject")
  #   new_version.set_html_content("<%body%>")
  #   new_version.set_plain_content("<%body%>")
  #   new_version.set_active(1)
  #   versions = SendgridTemplateEngine::Versions.new(@username, @password)
  #   expected = versions.post(template.id, new_version)
  #
  #   actual = versions.get(template.id, version.id)
  #
  #   assert_equal(expected.id, actual.id)
  #   assert_equal(expected.template_id, actual.template_id)
  #   assert_equal(expected.active, actual.active)
  #   assert_equal(expected.name, actual.name)
  #   assert_equal(expected.html_content, actual.html_content)
  #   assert_equal(expected.plain_content, actual.plain_content)
  #   assert_equal(expected.subject, actual.subject)
  #   assert_equal(expected.updated_at, actual.updated_at)
  # end

  # def test_post_name_nil
  #   templates = SendgridTemplateEngine::Templates.new(@username, @password)
  #   assert_raise(ArgumentError) {
  #     resp = templates.post(nil)
  #   }
  # end
  #
  # def test_post_bad_request
  #   templates = SendgridTemplateEngine::Templates.new(@username, @password)
  #   expect = ""
  #   assert_raise(RestClient::BadRequest) {
  #     resp = templates.post(expect)
  #   }
  # end
  #
  # def test_post
  #   #-- prepare test
  #   templates = SendgridTemplateEngine::Templates.new(@username, @password)
  #   resp_temps_all = templates.get_all()
  #   new_name = "new_template"
  #   if resp_temps_all.length > 0 then
  #     temp = templates.get(resp_temps_all[0].id).name
  #     new_name = temp + "1"
  #   end
  #   #-- prepare test
  #   actual = templates.post(new_name)
  #   assert_equal(true, actual.id.length > 0)
  #   assert_equal(new_name, actual.name)
  #   assert_equal(true, actual.versions.length == 0)
  # end
  #
  # def test_patch_id_nil
  #   templates = SendgridTemplateEngine::Templates.new(@username, @password)
  #   new_name = "new_name"
  #   assert_raise(ArgumentError) {
  #     actual = templates.patch(nil, new_name)
  #   }
  # end
  #
  # def test_patch_name_nil
  #   templates = SendgridTemplateEngine::Templates.new(@username, @password)
  #   id = "some_id"
  #   assert_raise(ArgumentError) {
  #     actual = templates.patch(id, nil)
  #   }
  # end
  #
  # def test_patch
  #   #-- prepare test
  #   templates = SendgridTemplateEngine::Templates.new(@username, @password)
  #   resp_temps_all = templates.get_all()
  #   new_name = "new_template"
  #   if resp_temps_all.length > 0 then
  #     temp = templates.get(resp_temps_all[0].id).name
  #     new_name = temp + "1"
  #   end
  #   expected = templates.post(new_name)
  #   #-- prepare test
  #   new_name += "2"
  #   actual = templates.patch(expected.id, new_name)
  #   assert_equal(expected.id, actual.id)
  #   assert_equal(new_name, actual.name)
  #   assert_equal(expected.versions, actual.versions)
  # end
  #
  # def test_delete_id_nil
  #   templates = SendgridTemplateEngine::Templates.new(@username, @password)
  #   assert_raise(ArgumentError) {
  #     templates.delete(nil)
  #   }
  # end
  #
  # def test_delete_not_exist
  #   templates = SendgridTemplateEngine::Templates.new(@username, @password)
  #   assert_raise(RestClient::ResourceNotFound) {
  #     templates.delete("not_exist")
  #   }
  # end
  #
  # def test_delete
  #   #-- prepare test
  #   templates = SendgridTemplateEngine::Templates.new(@username, @password)
  #   resp_temps_all = templates.get_all()
  #   new_name = "new_template"
  #   if resp_temps_all.length > 0 then
  #     temp = templates.get(resp_temps_all[0].id).name
  #     new_name = temp + "1"
  #   end
  #   expected = templates.post(new_name)
  #   #-- prepare test
  #   templates.delete(expected.id)
  #   assert_raise(RestClient::ResourceNotFound) {
  #     templates.get(expected.id)
  #   }
  # end

end
