module Metro
  module SceneView
    class Drawer

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

      def self.drawing_types
        @drawing_types
      end

      def self.draws(*args)
        @drawing_types = args.flatten.compact
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

      def drawers
        @drawers ||= begin
          hash = Hash.new(UnsupportedComponent)

          self.class.drawers.each do |drawer|
            drawer.drawing_types.each do |type|
              #TODO: Deal with the situation where one drawer overrides an existing drawer
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
          drawer = content['type']
          drawers[drawer].draw(content)
        end
      end

    end
  end
end

require_relative 'unsupported_component'
require_relative 'label'
require_relative 'select'
