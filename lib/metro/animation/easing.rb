module Easing
  module Linear
    extend self

    def linear(moment,start,change,interval)
      change * moment / interval + start
    end

    def calculate(start,final,interval)
      change = final - start
      (1..interval).map { |time| linear(time,start,change,interval) }
    end
  end

  module EaseIn
    extend self

    def ease_in_quad(moment,start,change,interval)
      change * (moment = moment / interval) * moment + start
    end

    def calculate(start,final,interval)
      change = final - start
      (1..interval).map { |time| ease_in_quad(time,start,change,interval) }
    end
  end
end

