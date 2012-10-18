module Metro
  module SceneView
    class Drawer

      def self.capable_of_drawing
        @capable_of_drawing
      end

      def self.draws(*args)
        @capable_of_drawing = args.flatten.compact
      end

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

      # The window is necessary as all drawing elements created require
      # an access to this instance.
      attr_reader :window

      # The scene is necessary to ensure that any fields which contain
      # variables within the application are properly interpolated.
      attr_reader :scene

      def initialize(scene)
        @scene = scene
        @window = scene.window
        after_initialize
      end

      def after_initialize ; end

      def components
        @components ||= begin
          hash = Hash.new(UnsupportedComponent)

          self.class.drawers.each do |drawer|
            drawer.capable_of_drawing.each do |type|
              hash[type] = drawer.new(scene)
            end
          end

          hash
        end
      end

      #
      # Render all the view elements defined that are supported by this drawer.
      #
      def draw(view)
        view.each do |name,content|
          component = content['type']

          components[component].draw(content)
        end
      end

    end
  end
end

require_relative 'unsupported_component'
require_relative 'label'
require_relative 'select'
