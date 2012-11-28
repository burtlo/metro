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
        of *string.to_s.split(",",2).map(&:to_f)
      end


      #
      # An alternate way of creating a dimensions object which
      # will enforce that the values added are converted to floating
      # point numbers.
      #
      def self.of(width=0.0,height=0.0)
        new width.to_f, height.to_f
      end

      def to_s
        "#{width},#{height}"
      end

      #
      # Add the dimensions to another dimensions-like structure. A
      # dimensions like structure is anything that responds to width and height.
      #
      # @return a new dimensions which is the sum of the two dimensions
      #
      def +(value)
        raise "Unable to add dimension to #{value} #{value.class}" if [ :width, :height ].find { |method| ! value.respond_to?(method) }
        self.class.of (width + value.width.to_f), (height + value.height.to_f)
      end

      #
      # Subtract the dimensions-like structure from this dimension. A
      # dimensions like structure is anything that responds to width and height.
      #
      # @return a new dimensions which is the different of the two dimensions
      #
      def -(value)
        raise "Unable to subtract from these dimensions with #{value} #{value.class}" if [ :width, :height ].find { |method| ! value.respond_to?(method) }
        self.class.of (width - value.width.to_f), (height - value.height.to_f)
      end

      def <=>(value)
        raise "Unable to subtract from these dimensions with #{value} #{value.class}" if [ :width, :height ].find { |method| ! value.respond_to?(method) }
        (width * height) <=> (value.width * value.height)
      end

    end
  end
end
