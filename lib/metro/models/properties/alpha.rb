module Metro
  class Model

    class AlphaProperty < Property
      def get(value)
        model.color.alpha
      end

      def set(value)
        model.color.alpha = value.to_i
      end
    end

  end
end