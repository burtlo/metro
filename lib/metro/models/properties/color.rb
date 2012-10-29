module Metro
  class Model

    class ColorProperty < Property

      def default_color
        @default_color ||= Gosu::Color.new "rgb(255,255,255)"
      end

      def get(value)
        value || default_color
      end

      def set(value)
        Gosu::Color.new value
      end
    end

  end
end