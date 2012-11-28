module Metro
  module Units

    #
    # An object that represents a rectanglar bounds.
    #
    class RectangleBounds

      # Allow the ability to refer to the min, max values with their
      # other alternate names.

      attr_accessor :left, :right, :top, :bottom

      def self.none
        new left: 0, right: 0, top: 0, bottom: 0
      end

      #
      # Create a bounds with bounds.
      #
      def initialize(params = {})
        @left = params[:left].to_f
        @top = params[:top].to_f
        @right = params[:right].to_f
        @bottom = params[:bottom].to_f
      end

      def top_left
        Point.at(left,top)
      end

      def top_right
        Point.at(right,top)
      end

      def bottom_right
        Point.at(right,bottom)
      end

      def bottom_left
        Point.at(left,bottom)
      end

      def dimensions
        Dimensions.of (right - left), (bottom - top)
      end

      def ==(value)
        return if [ :left, :right, :top, :bottom ].find { |method| ! value.respond_to?(method) }
        left == value.left and right == value.right and top == value.top and bottom == value.bottom
      end

      #
      # Does this bounds contain the following point?
      #
      def contains?(x,y)
        x > left and x < right and y > top and y < bottom
      end

      #
      # Does this rectanglular bounds intersect with another rectanglular bounds?
      #
      def intersect?(b)
        not(b.left > right or b.right < left or b.top > bottom or b.bottom < top)
      end

      def to_s
        "(#{left},#{top}) to (#{right},#{bottom})"
      end

    end

  end
end