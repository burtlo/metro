module Metro
  module Models

    class Rectangle < ::Metro::Model

      attr_accessor :x, :y, :z_order, :width, :height

      def after_initialize
        @x = @y = 0
        @z_order = 1
      end

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