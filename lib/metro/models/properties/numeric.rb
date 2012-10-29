module Metro
  class Model

    class NumericProperty < Property
      def get(value)
        value.to_f
      end

      def set(value)
        value.to_f
      end
    end

  end
end