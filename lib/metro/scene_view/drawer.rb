module Metro
  module SceneView

    class Drawer

      attr_reader :scene, :view, :window

      def initialize(scene)
        @scene = scene
        @window = scene.window
        @view = scene.view
      end

      def draw
        view.each do |name,content|
          send("draw_#{content['type']}",content) if respond_to? "draw_#{content['type']}"
        end
      end

      def font
        @font ||= Gosu::Font.new(window, Gosu::default_font_name, 20)
      end

      def draw_label(content)
        label_text = scene.instance_eval( "\"#{content['text']}\"" )

        font.draw label_text,
          content['x'], content['y'], content['z-order'],
          content['x-factor'] || 7.0, content['y-factor'] || 7.0,
          content['color'] || 0xffffffff
      end

      def draw_options(content) ; end

    end

  end
end