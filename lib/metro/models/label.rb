module Metro
  module Models

    #
    # Draws a string of text
    # 
    # @example Using the Label in a view file
    #    model: "metro::models::label"
    # 
    class Label < Model

      attr_accessor :x, :y, :x_factor, :y_factor, :z_order

      def initialize
        @x_factor = @y_factor = 1.0
      end

      def font
        @font ||= Gosu::Font.new(window, Gosu::default_font_name, 20)
      end

      def draw
        label_text = scene.instance_eval( "\"#{text}\"" )
        font.draw label_text, x, y, z_order, x_factor, y_factor, color
      end

    end
  end
end