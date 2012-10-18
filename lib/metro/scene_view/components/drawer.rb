module Metro
  module SceneView

    class Drawer

      # The window is necessary as all drawing elements created require
      # an access to this instance.
      attr_reader :window

      # The scene is necessary to ensure that any fields which contain
      # variables within the application are properly interpolated.
      attr_reader :scene

      def initialize(scene)
        @scene = scene
        @window = scene.window
      end

      def components
        @components ||= begin
          Hash.new(UnsupportedComponent).merge label: Label.new(scene)
        end
      end

      #
      # Render all the view elements defined that are supported by this drawer.
      #
      def draw(view)
        view.each do |name,content|
          component = content['type'].to_sym
          components[component].draw(content)
        end
      end

    end

  end
end

require_relative 'components/unsupported_component'
require_relative 'components/label'