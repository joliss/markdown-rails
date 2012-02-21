require 'redcarpet'
require 'action_view'

module Markdown
  module Rails
    class Handler
      def initialize
        @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
      end

      def call(template)
        # Return Ruby code that returns the compiled template
        @markdown.render(template.source).inspect + '.html_safe'
      end
    end
  end
end

handler = Markdown::Rails::Handler.new
ActionView::Template.register_template_handler(:md, handler)
ActionView::Template.register_template_handler(:markdown, handler)
