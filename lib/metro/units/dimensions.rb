module Metro
  module Units

    #
    # Represents an object that contains both the width and height.
    #
    class Dimensions < Struct.new(:width,:height)

      #
      # Create a dimensions objects with zero width and zero height.
      #
      def self.none
        of 0.0, 0.0
      end

      #
      # Parse a string representation of a dimensions object. The
      # supported formated is a comma-delimited string that contains
      # two attributes width and height.
      #
      def self.parse(string)
        of *string.split(",",2).map(&:to_f)
      end


      #
      # An alternate way of creating a dimensions object which
      # will enforce that the values added are converted to floating
      # point numbers.
      #
      def self.of(width,height)
        new width.to_f, height.to_f
      end

      def to_s
        "#{width},#{height}"
      end

    end
  end
end
