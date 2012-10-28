module Metro

  class AnimationFactory

    attr_reader :actor, :options, :on_complete_block

    def initialize(actor,options = {},&block)
      @actor = actor
      @options = options
      @on_complete_block = block
    end

  end

end