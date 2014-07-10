# -*- encoding: utf-8 -*-
require "json"
require "dotenv"
require "test/unit"
require "./lib/sendgrid_template_engine/version"

class TemplateTest < Test::Unit::TestCase

  def setup
   config = Dotenv.load
   @sendgrid_username = ENV["SENDGRID_USERNAME"]
   @sendgrid_password = ENV["SENDGRID_PASSWORD"]
  end

  def test_initialize
    templates = SendgridTemplateEngine::Templates.new()
    assert_equal(SendgridTemplateEngine::Templates, templates.class)
  end

  def test_get_invalid_auth
    templates = SendgridTemplateEngine::Templates.new()
    assert_raise(RestClient::Unauthorized) {
      response = templates.get_all("user", "pass")
    }
  end

  def test_get_nil
    templates = SendgridTemplateEngine::Templates.new()
    resp_temps = templates.get_all(@sendgrid_username, @sendgrid_password)
    assert_equal(true, resp_temps.length >= 0)
  end

  def test_get_template_id_not_exist
    templates = SendgridTemplateEngine::Templates.new()
    assert_raise(RestClient::ResourceNotFound) {
      response = templates.get(@sendgrid_username, @sendgrid_password, "not_exist")
    }
  end

  def test_get_template_id_exist
    templates = SendgridTemplateEngine::Templates.new()
    resp_temps_all = templates.get_all(@sendgrid_username, @sendgrid_password)
    expect_id = resp_temps_all[0].id
    expect_name = resp_temps_all[0].name
    expect_versions = resp_temps_all[0].versions

    if resp_temps_all.length > 0 then
      resp_temp = templates.get(@sendgrid_username, @sendgrid_password, expect_id)
      assert_equal(expect_id, resp_temp.id)
      assert_equal(expect_name, resp_temp.name)
      assert_equal(expect_versions, resp_temp.versions)
    end

  end

  def test_post_bad_request
    templates = SendgridTemplateEngine::Templates.new()
    expect = ""
    assert_raise(RestClient::BadRequest) {
      resp = templates.post(@sendgrid_username, @sendgrid_password, expect)
    }
  end

  def test_post
    templates = SendgridTemplateEngine::Templates.new()
    expect = "testtemplate8"
    resp = templates.post(@sendgrid_username, @sendgrid_password, expect)
    assert_equal(true, resp.id.length > 0)
    assert_equal(expect, resp.name)
    assert_equal(true, resp.versions.length == 0)
  end

  def test_patch
    templates = SendgridTemplateEngine::Templates.new()
    resp_temps_all = templates.get_all(@sendgrid_username, @sendgrid_password)
    expect_id = resp_temps_all[0].id
    expect_versions = resp_temps_all[0].versions
    expect_name = "newname"
    resp_temp = templates.patch(@sendgrid_username, @sendgrid_password, expect_id, expect_name)
    assert_equal(expect_id, resp_temp.id)
    assert_equal(expect_name, resp_temp.name)
    assert_equal(expect_versions, resp_temp.versions)
  end

  def test_delete
    templates = SendgridTemplateEngine::Templates.new()
    resp_temps_all = templates.get_all(@sendgrid_username, @sendgrid_password)
    expect_id = resp_temps_all[0].id
    expect_versions = resp_temps_all[0].versions

    templates.delete(@sendgrid_username, @sendgrid_password, expect_id)
    assert_raise(RestClient::ResourceNotFound) {
      resp_temp = templates.get(@sendgrid_username, @sendgrid_password, expect_id)
    }

  end

#   def test_get_template_id
#     templates = SendgridTemplateEngine::Templates.new()
#     response = templates.get(@sendgrid_username, @sendgrid_password)
#     res = JSON.parse(response.body)
#     puts res["templates"]
#     puts res["templates"][0]
#     puts res["templates"][0]["id"]
#
# #    puts response
# #    response = templates.get(@sendgrid_username, @sendgrid_password)
#
#   end

  # def test_send_bad_credential
  #   email = SendgridRuby::Email.new
  #   email.set_from('bar@foo.com').
  #     set_subject('test_send_bad_credential subject').
  #     set_text('foobar text').
  #     add_to('foo@bar.com')
  #
  #   sendgrid = SendgridRuby::Sendgrid.new("user", "pass")
  #   sendgrid.debug_output = true
  #   assert_raise RestClient::BadRequest do
  #     sendgrid.send(email)
  #   end
  # end
  #
  # def test_send
  #   email = SendgridRuby::Email.new
  #   email.set_from(@from).
  #     set_subject('test_send subject').
  #     set_text('foobar text').
  #     add_to(@to)
  #
  #   sendgrid = SendgridRuby::Sendgrid.new("user", "pass")
  #   sendgrid.debug_output = true
  #   assert_raise RestClient::BadRequest do
  #     sendgrid.send(email)
  #   end
  # end
  #
  # def test_send_with_attachment_text
  #   email = SendgridRuby::Email.new
  #   email.set_from(@from).
  #     set_subject('test_send_with_attachment_text subject').
  #     set_text('foobar text').
  #     add_to(@to).
  #     add_attachment('./test/file1.txt')
  #
  #   sendgrid = SendgridRuby::Sendgrid.new("user", "pass")
  #   sendgrid.debug_output = true
  #   assert_raise RestClient::BadRequest do
  #     sendgrid.send(email)
  #   end
  # end
  #
  # def test_send_with_attachment_binary
  #   email = SendgridRuby::Email.new
  #   email.set_from(@from).
  #     set_subject('test_send_with_attachment subject').
  #     set_text('foobar text').
  #     add_to(@to).
  #     add_attachment('./test/gif.gif')
  #
  #   sendgrid = SendgridRuby::Sendgrid.new("user", "pass")
  #   sendgrid.debug_output = true
  #   assert_raise RestClient::BadRequest do
  #     sendgrid.send(email)
  #   end
  # end
  #
  # def test_send_with_attachment_missing_extension
  #   email = SendgridRuby::Email.new
  #   email.set_from(@from).
  #     set_subject('test_send_with_attachment_missing_extension subject').
  #     set_text('foobar text').
  #     add_to(@to).
  #     add_attachment('./test/gif')
  #
  #   sendgrid = SendgridRuby::Sendgrid.new("user", "pass")
  #   sendgrid.debug_output = true
  #   assert_raise RestClient::BadRequest do
  #     sendgrid.send(email)
  #   end
  # end
  #
  # def test_send_with_ssl_option_false
  #   email = SendgridRuby::Email.new
  #   email.set_from(@from).
  #     set_subject('test_send_with_ssl_option_false subject').
  #     set_text('foobar text').
  #     add_to(@to)
  #
  #   sendgrid = SendgridRuby::Sendgrid.new("user", "pass", {"turn_off_ssl_verification" => true})
  #   sendgrid.debug_output = true
  #   assert_raise RestClient::BadRequest do
  #     sendgrid.send(email)
  #   end
  # end
  #
  # def test_send_unicode
  #   email = SendgridRuby::Email.new
  #   email.add_to(@to)
  #   .set_from(@from)
  #   .set_from_name("送信者名")
  #   .set_subject("[sendgrid-ruby-example] フクロウのお名前はfullnameさん")
  #   .set_text("familyname さんは何をしていますか？\r\n 彼はplaceにいます。")
  #   .set_html("<strong> familyname さんは何をしていますか？</strong><br />彼はplaceにいます。")
  #   .add_substitution("fullname", ["田中 太郎", "佐藤 次郎", "鈴木 三郎"])
  #   .add_substitution("familyname", ["田中", "佐藤", "鈴木"])
  #   .add_substitution("place", ["office", "home", "office"])
  #   .add_section('office', '中野')
  #   .add_section('home', '目黒')
  #   .add_category('カテゴリ1')
  #   .add_header('X-Sent-Using', 'SendgridRuby-API')
  #   .add_attachment('./test/gif.gif', 'owl.gif')
  #
  #   sendgrid = SendgridRuby::Sendgrid.new("user", "pass")
  #   sendgrid.debug_output = true
  #   assert_raise RestClient::BadRequest do
  #     sendgrid.send(email)
  #   end
  #
  # end

end
