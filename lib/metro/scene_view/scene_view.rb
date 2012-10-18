require_relative 'yaml_view'
require_relative 'json_view'
require_relative 'no_view'

module Metro

  #
  # SceneView provides support for a Scene to have a view as well as giving
  # additional tools to also help draw that view.
  #
  module SceneView

    #
    # When the module is included insure that all the class helper methods are added
    # at the same time. As well as re-defining the {Scene#base_draw} method to allow
    # for the use of the view_drawer.
    #
    def self.included(base)
      base.extend ClassMethods

      base.send :define_method, :base_draw do
        view_drawer.draw(view)
        draw
      end
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

    def view_drawer
      @view_drawer ||= SceneView::Drawer.new(self)
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