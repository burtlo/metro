module Metro
  module Models

    #
    # Draws an Image
    # 
    # @example Using the Image in a view file
    #    model: "metro::models::image"
    # 
    class Image < Model

      attr_accessor :x, :y, :angle, :center_x, :center_y, :x_factor, :y_factor, :z_order

      def after_initialize
        @angle = 0
        @center_x = @center_y = 0.5
        @x_factor = @y_factor = 1
        @z_order = 0
        @color = Gosu::Color.new "rgba(255,255,255,1.0)"
        @x = Game.width / 2
        @y = Game.height / 2
      end

      def image
        @image ||= Gosu::Image.new(window,asset_path(path))
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