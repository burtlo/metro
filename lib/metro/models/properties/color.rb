module Metro
  class Model

    class ColorProperty < Property

      define_property :alpha

      get_or_set NilClass do |value|
        default_color
      end

      get_or_set String do |value|
        Gosu::Color.new value
      end

      get_or_set Gosu::Color do |value|
        value
      end

      def default_color
        Gosu::Color.new(options[:default] || "rgb(255,255,255)")
      end

    end

  end
end