module Metro
  class Model

    class XPositionProperty < Property
      def get(value)
        value.to_f == 0.0 ? (Game.width/2 - model.font.text_width(model.text)/2) : value.to_f
      end

      def set(value)
        value.to_f
      end
    end

  end
end