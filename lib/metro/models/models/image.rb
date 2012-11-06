module Metro
  module Models

    #
    # Draws an Image
    #
    # @example Using the Image in a view file
    #    model: "metro::models::image"
    #
    class Image < Model

      property :position

      property :scale, type: ScaleableProperty, default: Scale.default

      property :z_order, type: :numeric, default: 1

      property :color

      property :angle, type: :numeric, default: 0

      property :center_x, type: :numeric, default: 0.5
      property :center_y, type: :numeric, default: 0.5

      property :image

      def contains?(x,y)
        bounds.contains?(x,y)
      end

      def bounds
        Bounds.new x - (width * center_x), y - (height * center_y), x + (width * center_x), y + (height * center_y)
      end

      def width
        image.width
      end

      def height
        image.height
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