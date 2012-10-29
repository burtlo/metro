module Metro
  module Models

    #
    # Draws an Image
    #
    # @example Using the Image in a view file
    #    model: "metro::models::image"
    #
    class Image < Model

      property :x, XPositionProperty
      property :y, YPositionProperty
      property :x_factor, MultiplierProperty
      property :y_factor, MultiplierProperty
      property :z_order, NumericProperty

      property :color, ColorProperty
      property :alpha, AlphaProperty

      property :angle, NumericProperty
      
      attr_accessor :center_x, :center_y

      def after_initialize
        @center_x = @center_y = 0.5
      end

      def image
        @image ||= Gosu::Image.new(window,asset_path(path))
      end

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