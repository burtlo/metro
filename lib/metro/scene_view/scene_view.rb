require_relative 'json_view'
require_relative 'no_view'

module Metro
  module SceneView

    def self.included(base)
      base.extend ClassMethods
    end

    def _view_parsers
      [ JSONView, NoView ]
    end

    def view
      @view ||= begin
        parser = _view_parsers.find { |parser| parser.find self.class.view_name }
        parser.parse self.class.view_name
      end
    end

    module ClassMethods

      def view_name(filename = nil)
        if filename
          @view_name = File.join "views", filename.to_s
        else
          @view_name ||= File.join "views", "#{self.to_s[/^(.+)Scene$/,1].downcase}"
        end
      end

    end

  end
end