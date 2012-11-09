module Metro
  module Models

    #
    # Draws a string of text
    #
    # @example Using the Label in a view file
    #    model: "metro::models::label"
    #
    class Label < Model

      property :position

      property :scale, default: Scale.one

      property :color, default: "rgba(255,255,255,1.0)"

      property :font, default: { size: 20 }

      property :text

      property :dimensions do
        Dimensions.of (font.text_width(text) * x_factor), (font.height * y_factor)
      end

      def bounds
        Bounds.new x: x, y: y, width: width, height: height
      end

      def contains?(x,y)
        bounds.contains?(x,y)
      end

      def draw
        font.draw text, x, y, z_order, x_factor, y_factor, color
      end

    end
  end
end