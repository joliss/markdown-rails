require 'temple'
require 'redcarpet'
require 'temple/mixins/dispatcher' # temple issue #58
require 'action_view'

module Markdown
  module Rails
    class Parser
      def initialize(options = {})
        @options = options

        @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
      end

      def call(exp)
        [:static, @markdown.render(exp.source)]
      end
    end

    class Engine < Temple::Engine
      use ::Markdown::Rails::Parser

      generator :ArrayBuffer
    end
  end
end

engine = Markdown::Rails::Engine.new
ActionView::Template.register_template_handler(:md, engine)
ActionView::Template.register_template_handler(:markdown, engine)
