module Metro
  class Model

    class MultiplierProperty < Property
      def get(value)
        value.to_f == 0.0 ? 1.0 : value.to_f
      end

      def set(value)
        value.to_f
      end
    end

  end
end