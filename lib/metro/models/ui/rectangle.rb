module Metro
  module UI

    class Rectangle < ::Metro::Model

      property :position

      property :color

      property :dimensions do
        # By default the dimensions of the rectangle will be the size of the window
        window.dimensions
      end

      def left_x
        x
      end

      def right_x
        x + width
      end

      def top_y
        y
      end

      def bottom_y
        y + height
      end

      def draw
        window.draw_quad(left_x,top_y,color,
          right_x,top_y,color,
          right_x,bottom_y,color,
          left_x,bottom_y,color,
          z_order)
      end
    end
  end
end