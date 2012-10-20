require_relative 'easing'

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
  class ImplicitAnimation < Animation

    #
    # @return the array of attributes that are being animated.
    #
    attr_reader :attributes

    #
    # @return a Hash that contains all the animation step deltas
    #   for each attribute.
    #
    attr_reader :deltas

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
      @deltas = {}

      @attributes = to.map { |attribute,final| attribute }

      to.each do |attribute,final|
        start = actor.send(attribute)
        deltas[attribute] = stepping(easing).calculate(start,final,interval)
      end
    end

    #
    # @return the correct easing based on the specified name. When the name
    #   provided does not match anything then default to linear easing.
    #
    def stepping(stepping)
      @steppings ||= begin
        hash = Hash.new(Easing::Linear)
        hash.merge! linear: Easing::Linear,
          ease_in: Easing::EaseIn
      end
      @steppings[stepping]
    end

    #
    # The ImplicitAnimation overrides the {Animation#execute_step} and
    # updates the attributes of the actor based upon the value of the
    # current animation step.
    #
    def execute_step
      attributes.each do |attribute|
        actor.send "#{attribute}=", delta_for_step(attribute)
      end
    end

    #
    # @return the delta for the attribute for the given step
    #
    def delta_for_step(attribute)
      deltas[attribute].at(current_step)
    end

  end
end