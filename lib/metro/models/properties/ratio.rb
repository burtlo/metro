module Metro
  class Model

    class RatioProperty < Property

      def get(value)
        value.to_f
      end

      def set(value)
        value = (value.to_f > 1.0 ? 1.0 : value.to_f)
        value = (value.to_f < 0.0 ? 0.0 : value.to_f)
        value
      end

    end

  end
end