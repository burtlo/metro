module Metro
  module Units

    #
    # An object that represents a rectanglar bounds.
    #
    class RectangleBounds < Struct.new(:min_x,:min_y,:max_x,:max_y)

      # Allow the ability to refer to the min, max values with their
      # other alternate names.

      alias_method :left, :min_x
      alias_method :left=, :min_x=
      alias_method :right, :max_x
      alias_method :right=, :max_x=
      alias_method :top, :min_y
      alias_method :top=, :min_y=
      alias_method :bottom, :max_y
      alias_method :bottom=, :max_y=

      #
      # Create a bounds with bounds.
      #
      def initialize(params = {})
        self.min_x = params[:x] || params[:min_x]
        self.min_y = params[:y] || params[:min_y]
        self.max_x = (params[:max_x] || (min_x + params[:width]))
        self.max_y = (params[:max_y] || (min_y + params[:height]))
      end

      #
      # Does this bounds contain the following point?
      #
      def contains?(x,y)
        x > min_x and x < max_x and y > min_y and y < max_y
      end

      #
      # Does this rectanglular bounds intersect with another rectanglular bounds?
      #
      def intersect?(b)
        not(b.min_x > max_x or b.max_x < min_x or b.min_y > max_y or b.max_y < min_y)
      end

      def to_s
        "(#{min_x},#{min_y}) to (#{max_x},#{max_y})"
      end

    end

  end
end