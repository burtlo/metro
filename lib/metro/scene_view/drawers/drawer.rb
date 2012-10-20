module Metro
  module SceneView

    #
    # A Drawer subclass does all the artistic work defined in the view granted by
    # the {SceneView}. A Drawer at it's core defines a subclass which species
    # the things that it can draw and then the draw method which it will draw
    # those things.
    #
    # @example Creating a drawer to handle lines
    #
    #     class Line < Metro::SceneView::Drawer
    #       draws :lines
    #
    #       def draw(view)
    #         # Code would draw a line from:
    #         #    view['x1'],view['y1'] to view['x2'],view['y2']
    #         # with a thickness of view['thickness']
    #       end
    #     end
    #
    class Drawer

      #
      # Allows a Drawer to specify what 'type' components it is able to draw. The
      # 'type' is defined within the view objects.
      #
      #     class LabelDrawer < Metro::SceneView::Drawer
      #       draws 'labels', 'shiny-labels', 'pulsing-labels'
      #     end
      #
      # @param [String,Array<String>] args a list of 'types' that this drawer is capable
      #   of drawing.
      #
      def self.draws(*args)
        @draws_types = args.flatten.compact.reject {|arg| arg.is_a? Hash }
        @draws_options = args.flatten.compact.find {|arg| arg.is_a? Hash }
      end

      #
      # This method is called right after initialization. Allowing for additional
      # configuration.
      #
      # @note This method should be implemented in the Drawer subclass.
      #
      def after_initialize ; end

      #
      # This method is called on the Drawer so that it renders content.
      #
      # @note This method should be implemented in the Drawer subclass.
      #
      # @param [Hash] view the hash content of the view.
      #
      def draw(view=nil) ; end

      #
      # @return the instance of window that is often necessary to create Gosu
      #   components for rendering.
      #
      attr_reader :window

      #
      # @return the scene that is being drawn. This is required if the view content
      #   requires live information from the scene or if the drawing is effected
      #   by the state of the scene.
      #
      attr_reader :scene

      #
      # Captures all classes that subclass Drawer.
      #
      def self.inherited(base)
        drawers << base
      end

      #
      # All subclasses of Drawer, this should be all the defined scenes within the game.
      #
      # @return an Array of Drawer subclasses
      #
      def self.drawers
        @drawers ||= []
      end

      #
      # @return an array of all the types of components that this Drawer
      #   is able to handle drawing.
      #
      def self.draws_types
        Array(@draws_types)
      end
      
      def self.draw_options
        @draws_options || {}
      end

      #
      # This initialize sets up the drawer. If a subclass Drawer needs to perform
      # some customization, it is prefered to call {#after_initialize}.
      #
      # @see #after_initialize
      #
      # @param [Scene] scene the scene that this Drawer is going to be drawing. A
      #   window is retrieved from the scene.
      #
      def initialize(scene)
        @scene = scene
        @window = scene.window
        after_initialize
      end

    end
  end
end