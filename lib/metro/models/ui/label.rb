module Metro
  module UI

    #
    # Draws a string of text
    #
    # @example Using the Label in a view file
    #    model: "metro::models::label"
    #
    class Label < Model

      property :position

      property :scale, default: Scale.one

      property :color, default: "rgba(255,255,255,1.0)"

      property :font, default: { size: 20 }

      property :text

      property :align, type: :text, default: "left"
      property :vertical_align, type: :text, default: "top"

      property :dimensions do
        Dimensions.of (font.text_width(text) * x_factor), (font.height * y_factor)
      end

      def bounds
        Bounds.new x: x, y: y, width: width, height: height
      end

      def contains?(x,y)
        bounds.contains?(x,y)
      end

      def x_center_alignment
        x - width / 2
      end

      def x_right_alignment
        x - width
      end

      def horizontal_alignments
        { left: x,
          center: x_center_alignment,
          right: x_right_alignment }
      end

      def x_position
        horizontal_alignments[align.to_sym]
      end

      def y_center_alignment
        y - height / 2
      end

      def y_bottom_alignment
        y - height
      end

      def vertical_alignments
        { top: y,
          center: y_center_alignment,
          bottom: y_bottom_alignment }
      end

      def y_position
        vertical_alignments[vertical_align.to_sym]
      end

      def draw
        font.draw text, x_position, y_position, z_order, x_factor, y_factor, color
      end

    end
  end
end