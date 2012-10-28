require_relative 'control_definition'

module Metro
  #
  # Assists in creating and the storing of ControlDefinitions.
  #
  # @see DSL
  #
  class Controls

    #
    # Creation through controls is usually done with an instance_eval
    # of a block and this allows for a flexible interface.
    #
    # @param [String,Symbol] name the name or the alias of the control
    #   as it will be used within the course of the game.
    #
    def method_missing(name,*params,&block)
      options = params.find {|param| param.is_a? Hash }
      define_control(name,options)
    end

    def define_control(name,options)
      event = _event_type(options)
      args = _event_args(options)

      defined_controls.push ControlDefinition.new name, event, args
    end

    def _event_type(options)
      options[:is]
    end

    def _event_args(options)
      options[:with]
    end

    def defined_controls
      @defined_controls ||= []
    end
  end
end