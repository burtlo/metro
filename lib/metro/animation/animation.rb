module Metro

  #
  # Animation is the motion that gives a system it's life. An animation
  # in this case is a really a mechanism that allows for an action to
  # be repeated for a given interval of time.
  #
  class Animation

    def initialize(options)
      @current_step = 0

      options.each do |key,value|
        send :instance_variable_set, "@#{key}".to_sym, value
        self.class.send :define_method, key do
          instance_variable_get("@#{key}")
        end
      end
      after_initialize
    end

    #
    # Sets the action that happens with each step of the animation.
    #
    def on_step(&block)
      @step_block = block
    end

    #
    # Sets the action that happens when the animation is completed.
    #
    def on_complete(&block)
      @complete_block = block
    end

    #
    # Perform a step of an animation, if it hasn't already been completed.
    #
    def step!
      return if completed?

      execute_step
      next_step

      complete! if completed?
    end

    #
    # @return the current step of the animation.
    #
    attr_reader :current_step

    attr_reader :step_block, :complete_block

    #
    # Move to the next step in the animation.
    #
    def next_step
      @current_step = current_step + step_interval
    end

    #
    # @return the interval at which the animation take place.
    #
    def step_interval
      1
    end
    
    # 
    # @return true if the animation has completed all the actions, false
    #   if there are remaining actions.
    # 
    def completed?
      current_step >= interval
    end

    #
    # Perform the action that happens with each step of the animation.
    #
    def execute_step
      context.instance_eval(&@step_block) if step_block and context
    end

    #
    # Perform the action that happens when the animation is completed.
    #
    def complete!
      context.instance_eval(&@complete_block) if complete_block and context
    end

  end
end

require_relative 'implicit_animation'
