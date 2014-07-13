# SendgridTemplateEngine

This gem allows you to quickly and easily access to SendGrid Template Engine using Ruby.
See [api reference](https://sendgrid.com/docs/API_Reference/Template_Engine_API/index.html) for more detail

[![Build Status](https://travis-ci.org/awwa/sendgrid_template_engine_ruby.svg?branch=master)](https://travis-ci.org/awwa/sendgrid_template_engine_ruby.svg?branch=master)

## Installation

Add this line to your application's Gemfile:

    gem 'sendgrid_template_engine'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sendgrid_template_engine

## Usage

### Templates
```Ruby
#
# Retrieve all templates
#
templates = SendgridTemplateEngine::Templates.new("user", "pass")
tmps = templates.get_all()
tmps.each {|tmp|
  puts tmp.id
  puts tmp.name
  tmp.versions.each {|ver|
    puts ver.id
    puts ver.template_id
    puts ver.active
    puts ver.name
    puts ver.updated_at
  }
}

#
# Retrieve a single template
#
templates = SendgridTemplateEngine::Templates.new("user", "pass")
tmp = templates.get(template_id)
puts tmp.id
puts tmp.name
tmp.versions.each {|ver|
  puts ver.id
  puts ver.template_id
  puts ver.active
  puts ver.name
  puts ver.updated_at
}

#
# Create a template
#
templates = SendgridTemplateEngine::Templates.new(@username, @password)
tmp = templates.post("new_template_name")

#
# Edit a template
#
templates = SendgridTemplateEngine::Templates.new(@username, @password)
tmp = templates.patch("edit_template_name")

#
# Delete a template
#
templates = SendgridTemplateEngine::Templates.new(@username, @password)
tmp = templates.delete(template_id)
```

### Versions
```Ruby
#
# Retrieve a specific version of template
#
versions = SendgridTemplateEngine::Versions.new(@username, @password)
ver = versions.get(template_id, version_id)
puts ver.id
puts ver.template_id
puts ver.active
puts ver.name
puts ver.html_content
puts ver.plain_content
puts ver.subject
puts ver.update_at

#
# Create a new version
#
new_version = SendgridTemplateEngine::Version.new()
new_version.set_name("new_version")
new_version.set_subject("<%subject%>")
new_version.set_html_content("<%body%>")
new_version.set_plain_content("<%body%>")
new_version.set_active(1)
versions = SendgridTemplateEngine::Versions.new(@username, @password)
ver = versions.post(template_id, new_version)

#
# Activate a version
#
versions = SendgridTemplateEngine::Versions.new(@username, @password)
ver = versions.post_activate(template_id, version_id)

#
# Edit a version
#
edit_version = SendgridTemplateEngine::Version.new()
edit_version.set_name("edit_version")
edit_version.set_subject("edit<%subject%>edit")
edit_version.set_html_content("edit<%body%>edit")
edit_version.set_plain_content("edit<%body%>edit")
edit_version.set_active(0)
versions = SendgridTemplateEngine::Versions.new(@username, @password)
ver = versions.patch(template_id, version_id, edit_version)

#
# Delete a version
#
versions = SendgridTemplateEngine::Versions.new(@username, @password)
versions.delete(template_id, version_id)

```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/sendgrid_template_engine/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
