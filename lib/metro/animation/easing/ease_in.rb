module Metro
  class Easing

    #
    # Perform a ease-in motion between the start position and the final position.
    #
    class EaseIn < Easing
      def self.calculation(moment,start,change,interval)
        change * (moment = moment / interval) * moment + start
      end
    end

    register :ease_in, EaseIn
  end
end