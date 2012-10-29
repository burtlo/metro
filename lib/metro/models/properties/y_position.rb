module Metro
  class Model

    class YPositionProperty < Property
      def get(value)
        value.to_f == 0.0 ? (Game.height/2 - model.font.height/2) : value.to_f
      end

      def set(value)
        value.to_f
      end
    end

  end
end