require_relative 'yaml_view'
require_relative 'json_view'
require_relative 'no_view'

module Metro
  module SceneView

    def self.included(base)
      base.extend ClassMethods
    end

    #
    # Supported view formats
    #
    def _view_parsers
      [ YAMLView, JSONView, NoView ]
    end

    #
    # Loads the view based on the view parsers.
    #
    def view
      @view ||= begin
        parser = _view_parsers.find { |parser| parser.find self.class.view_name }
        parser.parse self.class.view_name
      end
    end

    module ClassMethods

      #
      # A Scene by default uses the name of the Scene to find it's associated
      # view.
      #
      # @example Custom View Name
      #
      #     class ClosingScene < Metro::Scene
      #       view_name :alternate
      #     end
      #
      def view_name(filename = nil)
        if filename
          @view_name = File.join "views", filename.to_s
        else
          @view_name ||= File.join "views", scene_name
        end
      end

    end

  end
end