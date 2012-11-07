module Metro
  module Models

    class Rectangle < ::Metro::Model

      property :position

      property :z_order, type: :numeric, default: 0

      property :color

      attr_writer :width, :height

      def width
        @width || window.width
      end

      def height
        @height || window.height
      end

      def draw
        window.draw_quad(x,y,color,width,x,color,
                         width,height,color,y,height,color,
                         z_order)
      end
    end
  end
end