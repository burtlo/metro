module Metro
  module Units

    #
    # Represents an object that contains the x scale factor, and y scale factor.
    #
    class Scale < Struct.new(:x_factor,:y_factor)

      #
      # Create a scale that is 1:1.
      #
      def self.one
        new 1.0, 1.0
      end

      #
      # An alternative way to create a scale which will automatically convert
      # the inputs into floating numbers.
      #
      def self.to(x,y)
        new x.to_f, y.to_f
      end

      #
      # Parse a string representation of a scale object. The
      # supported formated is a comma-delimited string that contains
      # two attributes x-factor and y-factor.
      #
      def self.parse(string)
        to *string.split(",",2).map(&:to_f)
      end

      def to_s
        "#{x_factor},#{y_factor}"
      end

    end
  end
end