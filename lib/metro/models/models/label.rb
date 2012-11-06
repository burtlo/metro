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

      def draw
        font.draw text, x, y, z_order, x_factor, y_factor, color
      end

    end
  end
end