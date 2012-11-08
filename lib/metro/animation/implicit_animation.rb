require_relative 'easing/easing'

module Metro

  #
  # An Implicit Animation is an animation without all the work.
  # This little animation will take care of figuring out moving an
  # actor from one position to another, the rotation, the alpha,
  # etc.
  #
  # @example Creating an explicit animation that moves a player
  #
  #     animation = ImplicitAnimation.new actor: player,
  #       to: { x: final_x, y: final_y },
  #       interval: 80,
  #       easing: :ease_in,
  #       context: scene
  #
  #     animation.on_complete do
  #       transition_to :main
  #     end
  #
  # Here an animation is created that will move the player to the
  # position (final_x,final_y), specified in the :to hash that is
  # provided, over the interval of 80 steps. Additionally the movement
  # is done with an easing in.
  #
  # @note The actor object must respond to setter methods that match
  #   the specified attributes (e.g. x, y).
  #
  # The context provided is the context that the 'on_complete' block
  # is executed. In this case, upon completition, transition the scene
  # from the current one to the main scene.
  #
  class ImplicitAnimation < OnUpdateOperation

    def animations
      @animations ||= []
    end

    #
    # @return the type of easing that the implicit animation should employ.
    #   By default it uses linear but can be overridden when the easing is
    #   configured.
    #
    attr_reader :easing

    #
    # Additional initializion is required to calculate the attributes
    # that are going to be animated and to determine each of their deltas.
    #
    def after_initialize
      to.each do |attribute,final|
        start = actor.send(attribute)
        animations.push build_animation_step(attribute,start,final)
      end
    end

    def build_animation_step(attribute,start,final)
      step = AnimationStep.new
      step.actor = actor
      step.attribute = attribute
      step.deltas = easing_for(easing).calculate(start.to_f,final.to_f,interval.to_f)
      step
    end

    class AnimationStep
      attr_accessor :actor, :attribute, :deltas

      def execute_step(step)
        actor.set(attribute,deltas.at(step))
      end
    end

    #
    # @return the correct easing based on the specified name. When the name
    #   provided does not match anything then default to linear easing.
    #
    def easing_for(name)
      Metro::Easing.easing_for(name)
    end

    #
    # The ImplicitAnimation overrides the {Animation#execute_step} and
    # updates the attributes of the actor based upon the value of the
    # current animation step.
    #
    def execute_step
      animations.each {|step| step.execute_step(current_step) }
    end

    #
    # @return the delta for the attribute for the given step
    #
    def delta_for_step(attribute)
      deltas[attribute].at(current_step)
    end

  end
end