module Metro
  class Model

    class ScaleableProperty < Property

      define_property :x_factor,
        get: lambda { scaleable.x_factor },
        set: lambda {|val|
          current_scale = self.scaleable
          current_scale.x_factor = val
          self.scaleable = current_scale }

      define_property :y_factor,
        get: lambda { scaleable.y_factor },
        set: lambda {|val|
          current_scale = self.scaleable
          current_scale.y_factor = val
          self.scaleable = current_scale }

      get_or_set do |value|
        Scale.new default_x, default_y
      end

      get_or_set Scale do |value|
        value
      end

      get_or_set String do |value|
        x,y = value.split(",")
        Scale.new x.to_f, y.to_f
      end

      def default_x
        options[:default] ? options[:default].x_factor : 1.0
      end

      def default_y
        options[:default] ? options[:default].y_factor : 1.0
      end

    end

  end
end
