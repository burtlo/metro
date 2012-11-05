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

      property :scaleable, type: ScaleableProperty, default: Scale.default

      # property :x_factor, type: :multiplier, default: 1.0
      # property :y_factor, type: :multiplier, default: 1.0

      # property :scaleable
      #
      # scale (which sets both)
      # x_factor
      # y_factor
      #

      property :z_order, type: :numeric, default: 1

      property :color
      # alpha depends on color being present
      property :alpha

      property :font
      # This should be grouped together as a font
      # font
      # font_family
      # font_size
      property :font_family, type: :string
      property :font_size
      property :text

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