require 'rdiscount'
require 'action_view'

# We cannot use Markdown::Rails because it conflicts with RDiscount's Markdown class
module MarkdownRails
  class Handler
    def initialize
    end

    def call(template)
      # Return Ruby code that returns the compiled template
      MarkdownRails.renderer.call(template.source).inspect + '.html_safe'
    end
  end

  class <<self
    def configure
      yield self
    end

    attr_accessor :renderer

    def render(&block)
      self.renderer = block
    end
  end
end

MarkdownRails.configure do |config|
  config.render do |markdown_source|
    RDiscount.new(markdown_source).to_html
  end
end

handler = MarkdownRails::Handler.new
ActionView::Template.register_template_handler(:md, handler)
ActionView::Template.register_template_handler(:markdown, handler)
