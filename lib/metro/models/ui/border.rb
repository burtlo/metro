module Metro
  module UI

    #
    # Draws a rectanglar border around the specififed position and dimensions
    # with the width provided. This is an unfilled rectangle.
    #
    class Border < Metro::Model

      # @attribute
      # The starting position of the border.
      property :position

      # @attribute
      # The dimension of the border.
      property :dimensions

      # @attribute
      # The color which to use to draw the border.
      property :color, default: "rgba(255,255,255,1.0)"

      # @attribute
      # The width of the border lines
      property :border, default: 2

      def draw
        draw_border
      end

      def draw_border
        draw_top
        draw_bottom
        draw_left
        draw_right
      end

      def draw_top
        window.draw_quad(x + border,y,color,
          width + x,y,color,
          x + width,y + border,color,
          x + border,y + border,color,z_order)
      end

      def draw_left
        window.draw_quad(x,y,color,
          border + x,y,color,
          x + border,y + border + height,color,
          x,y + border + height,color,z_order)
      end

      def draw_right
        window.draw_quad(x + width,y,color,
          x + width + border,y,color,
          x + width + border,y + border + height,color,
          x + width,y + border + height,color,z_order)

      end

      def draw_bottom
        window.draw_quad(x + border,y + height,color,
          width + x,y + height,color,
          x + width,y + border + height,color,
          x + border,y + border + height,color,z_order)
      end

    end

  end
end