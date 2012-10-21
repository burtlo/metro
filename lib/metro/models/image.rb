module Metro
  module Models

    class Image < Model

      attr_accessor :angle, :center_x, :center_y, :factor_x, :factor_y

      def image
        @image ||= Gosu::Image.new(window,asset_path(path))
      end

      def draw
        image.draw_rot x, y, z_order,
          angle.to_f,
          center_x, center_y,
          factor_x, factor_y,
          color
      end

    end

  end
end