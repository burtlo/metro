module Metro
  module Units

    class RectangleBounds < Struct.new(:min_x,:min_y,:max_x,:max_y)

      alias_method :left, :min_x
      alias_method :right, :max_x
      alias_method :top, :min_y
      alias_method :bottom, :max_y

      def initialize(params = {})
        self.min_x = params[:x] || params[:min_x]
        self.min_y = params[:y] || params[:min_y]
        self.max_x = (params[:max_x] || (min_x + params[:width]))
        self.max_y = (params[:max_y] || (min_y + params[:height]))
      end

      def contains?(x,y)
        x > min_x and x < max_x and y > min_y and y < max_y
      end

      def to_s
        "(#{min_x},#{min_y}) to (#{max_x},#{max_y})"
      end

      def intersect(b)
        return not(b.min_x > max_x or b.max_x < min_x or b.min_y > max_y or b.max_y < min_y)
      end

    end

  end
end