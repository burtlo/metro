module Metro
  module UI

    #
    # The image will draw an image with the specifie path, color, rotation, and scale.
    #
    # @example Drawing the 'player.png' image at (320,240)
    #
    #     class MainScene < GameScene
    #       draw :player, model: "metro::ui::image", position: "320,240",
    #         image: "player.png"
    #     end
    #
    class Image < Model

      property :position

      property :scale, default: Scale.one

      property :color

      property :angle, type: :numeric, default: 0

      property :center_x, type: :numeric, default: 0.5
      property :center_y, type: :numeric, default: 0.5

      property :image

      property :dimensions do
        image.dimensions
      end

      def contains?(x,y)
        bounds.contains?(x,y)
      end

      def bounds
        Bounds.new x: x - (width * center_x),
                   y: y - (height * center_y),
                   width: width,
                   height: height
      end

      def draw
        image.draw_rot x, y, z_order,
          angle.to_f,
          center_x, center_y,
          x_factor, y_factor,
          color
      end

    end

  end
end