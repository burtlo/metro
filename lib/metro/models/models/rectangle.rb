module Metro
  module Models

    class Rectangle < ::Metro::Model

      property :position

      property :color

      property :dimensions do
        # By default the dimensions of the rectangle will be the size of the window
        model.window.dimensions
      end

      def draw
        window.draw_quad(x,y,color,
                         width,x,color,
                         width,height,color,
                         y,height,color,
                         z_order)
      end
    end
  end
end