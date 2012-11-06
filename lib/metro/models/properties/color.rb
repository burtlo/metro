module Metro
  class Model

    class ColorProperty < Property

      define_property :alpha

      get do |value|
        default_color
      end
      
      set do |value|
        default_color_string
      end

      get_or_set String do |value|
        create_color value
      end

      get Gosu::Color do |value|
        value
      end
      
      set Gosu::Color do |value|
        value.to_s
      end

      def default_color
        create_color(default_color_string)
      end
      
      def default_color_string
        options[:default] || "rgba(255,255,255,1.0)"
      end
      
      def create_color(value)
        Gosu::Color.new value
      end

    end

  end
end