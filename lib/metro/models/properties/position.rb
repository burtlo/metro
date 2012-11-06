module Metro
  class Model

    class PositionProperty < Property

      define_property :x

      define_property :y

      get_or_set do |value|
        Point.new default_x, default_y
      end

      get_or_set Point do |value|
        value
      end

      get_or_set String do |value|
        x,y = value.split(",")
        Point.new x.to_f, y.to_f
      end

      def default_x
        options[:default] ? options[:default].x : 0.0
      end

      def default_y
        options[:default] ? options[:default].y : 0.0
      end

    end

  end
end
