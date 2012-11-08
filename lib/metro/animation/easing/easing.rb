module Metro

  #
  # An easing is a means to calculate the steps between the start and the final
  # over an interval.
  #
  class Easing

    #
    # The calculate method is called within the ImplicitAnimation and will create
    # an array of all the states between the start and the final value.
    #
    def self.calculate(start,final,interval)
      change = final - start
      (1..interval).map { |time| calculation(time.to_f,start,change,interval) }
    end

    #
    # The calculation method is to be overriden in the Easing subclasses.
    # This calculation figures out the value at the current moemnt.
    #
    def self.calculation(moment,start,change,interval) ; 0 ; end

    #
    # Register an easing within the game system.
    #
    def self.register(name,easing_class)
      easings[name] = easing_class.to_s
    end

    #
    # @return the easing class based on the specified easing name.
    #
    def self.easing_for(easing)
      easing_classname = easings[easing]
      easing_classname.constantize
    end

    #
    # A hash of all the supported easings within metro or game.
    #
    def self.easings
      @easings_hash ||= HashWithIndifferentAccess.new("Metro::Easing::Linear")
    end

  end

end

require_relative 'linear'
require_relative 'ease_in'
