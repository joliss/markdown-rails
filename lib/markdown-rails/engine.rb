require 'rdiscount'
require 'action_view'

# We cannot use Markdown::Rails because it conflicts with RDiscount's Markdown class
module MarkdownRails
  class Handler
    # Build ruby code that will be evaluated in the view context.
    def call(template)
      src = <<-end_src
        MarkdownRails.renderer.call("#{template.source.gsub(/"/, '\"')}").html_safe
      end_src
    end

    # Allow for use of the class as a renderer in a reentrant way.
    def self.call(template)
      new.call(template)
    end
  end

  class <<self
    def configure
      yield self
    end

    attr_accessor :renderer

    # Stores the given block as a constructor for a new renderer.
    # When MarkdownRails.renderer.call(text) is called this block is executed and passed +text+.
    def render(&block)
      self.renderer = block
    end
  end
end

# Default configuration using RDiscount, a fast C Markdown implementation.
MarkdownRails.configure do |config|
  config.render do |markdown_source|
    RDiscount.new(markdown_source).to_html
  end
end

[:md, :markdown].each do |extension|
  # >= v3.0.5
  if defined? ActionView::Template::Handlers and ActionView::Template::Handlers.respond_to? :register_template_handler
    ActionView::Template::Handlers
  # >= v2.1.0 <= v2.1.0
  elsif defined? ActionView::Template and ActionView::Template.respond_to? :register_template_handler
    ActionView::Template
  # >= v2.2.1 <= v2.3.8
  elsif defined? ActionView::TemplateHandlers and ActionView::TemplateHandlers.respond_to? :register_template_handler
    ActionView::TemplateHandlers
  # <= v2.0.3
  elsif defined? ActionView::Base and ActionView::Base.respond_to? :register_template_handler
    ActionView::Base
  # I give up...
  else
    raise "Couldn't find `register_template_handler' method in ActionView module."
  end.register_template_handler extension, MarkdownRails::Handler
end
