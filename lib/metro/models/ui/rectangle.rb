module Metro
  module UI

    #
    # The rectangle will draw a rectangle from the specified position out to the specified
    # dimensions in the specified color.
    #
    # @example Drawing a red rectangle that starts at (20,20) and is 200 by 200
    #
    #     class IntroScene < GameScene
    #       draw :backdrop, model: "metro::ui::rectangle", position: "20,20",
    #         color: "rgba(255,0,0,1.0)", dimensions: "200,200"
    #     end
    #
    class Rectangle < ::Metro::Model

      property :position

      property :color

      property :dimensions do
        window.dimensions
      end

      def draw
        window.draw_quad(left_x,top_y,color,
          right_x,top_y,color,
          right_x,bottom_y,color,
          left_x,bottom_y,color,
          z_order)
      end

      private

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

    end
  end
end