# -*- encoding: utf-8 -*-
require "json"
require "dotenv"
require "test/unit"
require "./lib/templates"
require "./lib/sendgrid_template_engine/version"

class SendgridTemplateEngineTest < Test::Unit::TestCase

  def test_version
    assert_equal("0.0.2", SendgridTemplateEngine::VERSION)
  end

end
