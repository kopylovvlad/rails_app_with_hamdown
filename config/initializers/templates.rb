require 'cgi'

# sources
# http://railscasts.com/episodes/379-template-handlers?view=asciicast
# https://edruder.com/blog/2017/12/19/add-markdown-to-rails-5.html

# TODO: it should work as
# https://github.com/haml/haml/blob/master/lib/haml/plugin.rb
module ActionView
  module Template::Handlers
    class HamdownWithRender
      class_attribute :default_format
      self.default_format = Mime[:html]

      class << self
        def call(template)
          compiled_source = compile_with_render(template)
          "#{name}.render(begin;#{compiled_source};end)"
        end

        def render(template)
          template = CGI.unescapeHTML(template)
          ::Tilt::HamdownTemplate.new{}.render(template).html_safe
        end

        private

        def compile_with_render(template)
          compiled_source = '@output_buffer = output_buffer || ActionView::OutputBuffer.new;'

          lines = compile_view_with_render(template.identifier)
          compiled_source << lines.map do |(i, opt)|
            if opt[:type] == 1
              <<-end_src
                spaces = "#{' '*opt[:spaces].to_i}"
                string = #{i};
                string = string.split(/^/).join(spaces);
                string = spaces + string;
                @output_buffer.append=(string);
              end_src
            else
              %Q(@output_buffer.safe_append="#{CGI.escapeHTML(i)}".freeze;)
            end
          end.join("@output_buffer.safe_append='\n'.freeze;")
          compiled_source << '@output_buffer.to_s'
          compiled_source
        end

        def compile_view_with_render(file_path)
          file = File.open(file_path, 'r')
          view_content = file.read
          file.close
          render_view_with_render(view_content, file_path)
        end

        def render_view_with_render(content, file_path)
          content.split("\n").map do |str|
            if str =~ /\= render \'[0-9a-zA-z]*\'/
              spaces = str.scan(/^ */).first.size
              view_name = str.scan(/\= render \'([0-9a-zA-z]*)\'/).flatten.first

              ["(render '#{view_name}')", type: 1, spaces: spaces]
            else
              [str, type: 0]
            end
          end
        end
      end
    end
  end
end

ActionView::Template.register_template_handler(
  :hd, ActionView::Template::Handlers::HamdownWithRender
)
