module Metro
  module Units

    class RectangleBounds

      attr_reader :min_x, :min_y, :max_x, :max_y

      def initialize(min_x,min_y,max_x,max_y)
        @min_x = min_x
        @min_y = min_y
        @max_x = max_x
        @max_y = max_y
      end

      def contains?(x,y)
        x > min_x and x < max_x and y > min_y and y < max_y
      end

      def to_s
        "(#{min_x},#{min_y}) to (#{max_x},#{max_y})"
      end

    end

  end
end