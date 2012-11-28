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

      # @attribute
      # The position of the image
      property :position

      # @attribute
      # The scale of the image
      property :scale, default: Scale.one

      # @attribute
      # The color of the image, by default this is white to display the image
      # as normal, but this can be used to augment the look of the image. Mostly
      # color is use for the sub-property :alpha which allows an image to be
      # faded-in and faded-out
      property :color

      # @attribute
      # The angle at which to draw the image
      property :angle, type: :numeric, default: 0

      # @attribute
      # The center x position of the image as expressed in a scale of from left
      # to right (0.0 to 1.0).
      property :center_x, type: :numeric, default: 0.5

      # @attribute
      # The center y position of the image as expressed in a scale of from top
      # to bottom (0.0 to 1.0).
      property :center_y, type: :numeric, default: 0.5

      # @attribute
      # The image asset to draw.
      property :image

      # @attribute
      # The dimensions of the image.
      property :dimensions do
        image.dimensions
      end

      def bounds
        Bounds.new left: left_x, right: right_x, top: top_y, bottom: bottom_y
      end

      def draw
        image.draw_rot x, y, z_order,
          angle.to_f,
          center_x, center_y,
          x_factor, y_factor,
          color
      end

      private

      def left_x
        x - (width * center_x)
      end

      def right_x
        left_x + width
      end

      def top_y
        y - (height * center_y)
      end

      def bottom_y
        top_y + height
      end
    end

  end
end