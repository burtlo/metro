module Metro
  module Models

    #
    # Draws a string of text
    #
    # @example Using the Label in a view file
    #    model: "metro::models::label"
    #
    class Label < Model

      property :position, default: Game.center

      property :scale, type: ScaleableProperty, default: Scale.default

      property :z_order, type: :numeric, default: 1

      property :color

      property :font

      property :text

      def after_initialize
        @text = ""
        @x_factor = @y_factor = 1.0
        @z_order = 0
        @color = Gosu::Color.new "rgba(255,255,255,1.0)"
        @size = 20
        @font_family = Gosu::default_font_name
      end

      def bounds
        Bounds.new x, y, x + width, y + height
      end

      def width
        font.text_width(text) * x_factor
      end

      def height
        font.height * y_factor
      end

      def contains?(x,y)
        bounds.contains?(x,y)
      end

      def text
        scene.instance_eval( "\"#{@text}\"" )
      end

      attr_writer :text

      def draw
        label_text = text
        font.draw label_text, x, y, z_order, x_factor, y_factor, color
      end

    end
  end
end