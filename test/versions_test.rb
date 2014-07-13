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

  # def test_get_template_id_nil
  #   versions = SendgridTemplateEngine::Versions.new(@username, @password)
  #   assert_raise(ArgumentError) {
  #     response = versions.get(nil, "version_id")
  #   }
  # end
  #
  # def test_get_version_id_nil
  #   versions = SendgridTemplateEngine::Versions.new(@username, @password)
  #   assert_raise(ArgumentError) {
  #     response = versions.get("template_id", nil)
  #   }
  # end
  #
  # def test_get_not_exist
  #   versions = SendgridTemplateEngine::Versions.new(@username, @password)
  #   assert_raise(RestClient::ResourceNotFound) {
  #     response = versions.get("not_exist", "not_exist")
  #   }
  # end
  #
  # def test_get
  #   begin
  #     templates = SendgridTemplateEngine::Templates.new(@username, @password)
  #     # Add template
  #     new_template = templates.post("new_template")
  #     # Add version
  #     new_version = SendgridTemplateEngine::Version.new()
  #     new_version.set_name("new_version")
  #     new_version.set_subject("<%subject%>")
  #     new_version.set_html_content("<%body%>")
  #     new_version.set_plain_content("<%body%>")
  #     new_version.set_active(1)
  #     versions = SendgridTemplateEngine::Versions.new(@username, @password)
  #     new_version = versions.post(new_template.id, new_version)
  #     # Get version
  #     actual = versions.get(new_template.id, new_version.id)
  #     assert_equal(new_version.template_id, actual.template_id)
  #     assert_equal(new_version.active, actual.active)
  #     assert_equal(new_version.name, actual.name)
  #     assert_equal(new_version.html_content, actual.html_content)
  #     assert_equal(new_version.plain_content, actual.plain_content)
  #     assert_equal(new_version.subject, actual.subject)
  #     # Edit version
  #     edit_version = SendgridTemplateEngine::Version.new()
  #     edit_version.set_name("edit_version")
  #     edit_version.set_subject("edit<%subject%>edit")
  #     edit_version.set_html_content("edit<%body%>edit")
  #     edit_version.set_plain_content("edit<%body%>edit")
  #     edit_version.set_active(0)
  #     versions.patch(new_template.id, new_version.id, edit_version)
  #     # Get version
  #     actual = versions.get(new_template.id, new_version.id)
  #     assert_equal(new_template.id, actual.template_id)
  #     assert_equal(edit_version.active, actual.active)
  #     assert_equal(edit_version.name, actual.name)
  #     assert_equal(edit_version.html_content, actual.html_content)
  #     assert_equal(edit_version.plain_content, actual.plain_content)
  #     assert_equal(edit_version.subject, actual.subject)
  #     # Delete version
  #     versions.delete(actual.template_id, actual.id)
  #     assert_raise(RestClient::ResourceNotFound) {
  #       versions.get(new_template.id, new_version.id)
  #     }
  #     # Delete template
  #     templates.delete(actual.template_id)
  #   rescue => ex
  #     puts ex.inspect
  #   end
  # end

  def test_post_activate
    begin
      templates = SendgridTemplateEngine::Templates.new(@username, @password)
      # Add template
      new_template = templates.post("new_template")
      # Add version
      new_version = SendgridTemplateEngine::Version.new()
      new_version.set_name("new_version")
      new_version.set_subject("<%subject%>")
      new_version.set_html_content("<%body%>")
      new_version.set_plain_content("<%body%>")
      new_version.set_active(0)
      versions = SendgridTemplateEngine::Versions.new(@username, @password)
      new_version = versions.post(new_template.id, new_version)
      # Get version
      actual = versions.get(new_template.id, new_version.id)
      assert_equal(new_version.active, actual.active)
      # Activate version
      versions.post_activate(new_template.id, new_version.id)
      # Get version
      actual = versions.get(new_template.id, new_version.id)
      assert_equal(1, actual.active)
      # Delete version
      versions.delete(actual.template_id, actual.id)
      # Delete template
      templates.delete(actual.template_id)
    rescue => ex
      puts ex.inspect
    end
  end





  #
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
  # def test_patch_name_nil
  #   templates = SendgridTemplateEngine::Templates.new(@username, @password)
  #   id = "some_id"
  #   assert_raise(ArgumentError) {
  #     actual = templates.patch(id, nil)
  #   }
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

end
