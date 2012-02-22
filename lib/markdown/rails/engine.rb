require 'rdiscount'
require 'action_view'

module Markdown
  module Rails
    class Handler
      def initialize
      end

      def call(template)
        # Return Ruby code that returns the compiled template
        Markdown::Rails.renderer.call(template.source).inspect + '.html_safe'
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
end

Markdown::Rails.configure do |config|
  config.render do |markdown_source|
    RDiscount.new(markdown_source).to_html
  end
end

handler = Markdown::Rails::Handler.new
ActionView::Template.register_template_handler(:md, handler)
ActionView::Template.register_template_handler(:markdown, handler)
