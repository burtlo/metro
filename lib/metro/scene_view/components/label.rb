module Metro
  module SceneView
    class Label < Drawer
      draws 'label'

      def font
        @font ||= Gosu::Font.new(window, Gosu::default_font_name, 20)
      end

      def draw(view)
        label_text = scene.instance_eval( "\"#{view['text']}\"" )

        label_color = view['color'] || 0xffffffff
        label_color = label_color.to_i(16) if label_color.is_a? String

        font.draw label_text,
          view['x'], view['y'], view['z-order'],
          view['x-factor'] || 1.0, view['y-factor'] || 1.0,
          label_color
      end

    end
  end
end