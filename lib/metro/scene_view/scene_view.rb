require_relative 'yaml_view'
require_relative 'json_view'
require_relative 'no_view'

require_relative 'drawers/drawer'
require_relative 'drawers/composite_drawer'

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
    # Loads and caches the view content based on the avilable view parsers and
    # the view files defined.
    #
    # @return a Hash of view content.
    #
    def view
      @view ||= begin
        parser = _view_parsers.find { |parser| parser.exists? self.class.view_name }
        parser.parse self.class.view_name
      end
    end

    #
    # @return an instance of a SceneView::Drawer that is capable of drawing
    #   the Scene.
    def view_drawer
      @view_drawer ||= SceneView::CompositeDrawer.new(self)
    end

    module ClassMethods

      #
      # A Scene by default uses the name of the Scene to find it's associated
      # view.
      #
      # @example Custom View Name
      #
      #     class ClosingScene < Metro::Scene
      #       view_name 'alternative'
      #     end
      # 
      #     ClosingScene.view_name # => views/alternative
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