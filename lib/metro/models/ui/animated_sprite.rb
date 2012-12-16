module Metro
  module UI

    #
    # A sprite is a Metro model that is specially designed to draw and manage
    # an animation. A sprite maintains an animation, location information, and
    # rotation.
    #
    class AnimatedSprite < Model

      # @attribute
      # The animation that will be drawn for the sprite
      property :animation

      # @attribute
      # The point at which the sprite should be drawn
      property :position

      # @attribute
      # This is the color of the spirte. The color usually remains white, and
      # the color property is implemented by the `alpha` value is the one thing
      # that is altered to fade in and fade out the sprite.
      property :color

      # @attribute
      # The scale at which to draw the sprite. This is default scale of 1.
      property :scale

      # @attribute
      # The center, horizontal position, as expressed in a ratio, of the image.
      property :center_x, type: :numeric, default: 0.5

      # @attribute
      # The center, vertical position, as expressed in a ratio, of the image.
      property :center_y, type: :numeric, default: 0.5

      # @attribute
      # The angle at which the sprite should be drawn. This is by default 0.
      property :angle

      # @attribute
      # The height and width of the sprite is based on the image of the sprite.
      property :dimensions do
        Dimensions.of current_image.width, current_image.height
      end

      # @return [RectangleBounds] the bounds of the sprite.
      def bounds
        Bounds.new left: left, right: right, top: top, bottom: bottom
      end

      # @return [Float] the left-most x position of the sprite
      def left
        x - width * center_x
      end

      # @return [Float] the right-most x position of the sprite
      def right
        left + width * x_factor
      end

      # @return [Float] the top-most y position of the sprite
      def top
        y - height * center_y
      end

      # @return [Float] the bottom-most y position of the sprite
      def bottom
        top + height * y_factor
      end

      # @return [Gosu::Image] the current image in the animation sequence.
      def current_image
        animation.image
      end

      #
      # By default the sprite will draw the current image of the animation.
      #
      def draw
        current_image.draw_rot x, y, z_order, angle, center_x, center_y, x_factor, y_factor, color
      end
    end
  end
end