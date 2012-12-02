module Metro
  module UI

    #
    # Draws a rectanglar border around the specififed position and dimensions
    # with the width provided. This is an unfilled rectangle.
    #
    class Border < Model

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
        draw_line left_with_border, top, right, top_with_border
      end

      def draw_left
        draw_line left, top, left_with_border, bottom_with_border
      end

      def draw_right
        draw_line right, top, right_with_border, bottom_with_border
      end

      def draw_bottom
        draw_line left_with_border, bottom, right,bottom_with_border
      end

      def draw_line(start_x,start_y,finish_x,finish_y)
        window.draw_quad start_x, start_y, color,
          finish_x, start_y, color,
          finish_x, finish_y, color,
          start_x, finish_y, color, z_order
      end

      def left
        x
      end

      def left_with_border
        x + border
      end

      def right
        x + width
      end

      def right_with_border
        right + border
      end

      def top
        y
      end

      def top_with_border
        top + border
      end

      def bottom
        y + height
      end

      def bottom_with_border
        bottom + border
      end

    end

  end
end