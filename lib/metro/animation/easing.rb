module Metro
  class Easing

    def self.calculate(start,final,interval)
      change = final - start
      (1..interval).map { |time| calculation(time.to_f,start,change,interval) }
    end

    def self.calculation(moment,start,change,interval) ; 0 ; end
  end
  
  class Easing
    class Linear < Easing
      def self.calculation(moment,start,change,interval)
        change * moment / interval + start
      end
    end

    class EaseIn < Easing
      def self.calculation(moment,start,change,interval)
        change * (moment = moment / interval) * moment + start
      end
    end
  end

end
