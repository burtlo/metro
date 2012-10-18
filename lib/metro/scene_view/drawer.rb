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

        label_color = content['color'] || 0xffffffff
        label_color = label_color.to_i(16) if label_color.is_a? String

        font.draw label_text,
          content['x'], content['y'], content['z-order'],
          content['x-factor'] || 1.0, content['y-factor'] || 1.0,
          label_color
      end

      def draw_options(content) ; end

    end

  end
end