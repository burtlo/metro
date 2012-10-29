module Metro
  module Models

    #
    # Draws a string of text
    #
    # @example Using the Label in a view file
    #    model: "metro::models::label"
    #
    class Label < Model

      property :x, XPositionProperty
      property :y, YPositionProperty
      property :x_factor, MultiplierProperty
      property :y_factor, MultiplierProperty
      property :z_order, NumericProperty
      property :color, ColorProperty
      property :alpha, AlphaProperty

      property :font, FontProperty
      property :font_family, StringProperty
      property :font_size, FontSizeProperty
      property :text, StringProperty

      def after_initialize
        @text = ""
        @x_factor = @y_factor = 1.0
        @z_order = 0
        @color = Gosu::Color.new "rgba(255,255,255,1.0)"
        @size = 20
        @font_family = Gosu::default_font_name
      end

      def font
        @font ||= Gosu::Font.new(window, font_family, size)
      end

      def x
        @x || (Game.width/2 - font.text_width(text)/2)
      end

      def y
        @y || (Game.height/2 - font.height/2)
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