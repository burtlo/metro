module Metro
  class Model

    class FontSizeProperty < Property
      def get(value)
        value.to_i == 0 ? 20 : value.to_i
      end

      def set(value)
        value.to_i
      end
    end

  end
end