module Metro
  class Easing

    #
    # Perform a linear motion between the start position and the final position.
    #
    class Linear < Easing
      def self.calculation(moment,start,change,interval)
        change * moment / interval + start
      end
    end

    register :linear, Linear
  end
end