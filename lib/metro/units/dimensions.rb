module Metro
  module Units
    class Dimensions < Struct.new(:width,:height)

      def self.none
        of 0.0, 0.0
      end

      def self.parse(string)
        of *string.split(",",2).map(&:to_f)
      end

      def self.of(width,height)
        new width.to_f, height.to_f
      end

      def to_s
        "#{width},#{height}"
      end

    end
  end
end
