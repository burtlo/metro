module Metro
  module Units

    #
    # An object that represents a rectanglar bounds.
    #
    class RectangleBounds
      include CalculationValidations

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

      def add_change_listener(listener)
        listeners.push listener
      end

      def listeners
        @listeners ||= []
      end

      def notify_listeners
        listeners.each {|listener| listener.bounds_changed(self) }
      end

      def shift(point)
        self.left = self.left + point.x
        self.right = self.right + point.x
        self.top = self.top + point.y
        self.bottom = self.bottom + point.y
        notify_listeners
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
        check_calculation_requirements(value)
        left == value.left and right == value.right and top == value.top and bottom == value.bottom
      end

      #
      # Does this bounds contain the following point?
      #
      def contains?(point)
        point.x > left and point.x < right and point.y > top and point.y < bottom
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

      private

      def calculation_requirements
        [ :left, :right, :top, :bottom ]
      end

    end

  end
end