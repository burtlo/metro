module Metro

  class EventFactory

    attr_reader :event, :args, :block

    alias_method :buttons, :args

    def initialize(event,args=[],&block)
      @event = event
      @args = args
      @block = block
    end

  end

end