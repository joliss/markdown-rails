# -*- encoding: utf-8 -*-
require File.expand_path('../lib/markdown-rails/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "markdown-rails"
  s.version     = MarkdownRails::VERSION
  s.authors     = ["Jo Liss"]
  s.email       = ["joliss42@gmail.com"]
  s.homepage    = "https://github.com/joliss/markdown-rails"
  s.summary     = "Markdown as a Rails templating language"
  s.description = "Markdown as a static templating language for Rails views and partials"

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "rails"
  s.add_dependency "rdiscount", [">= 1.6.8", "< 2.0"]

  s.files        = `git ls-files`.split("\n").reject { |f| f =~ /^testapp/ }
  s.executables  = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_path = 'lib'
end
