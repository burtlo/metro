module Metro

  class EventFactory

    attr_reader :event, :buttons, :block

    def initialize(event,buttons = [],&block)
      @event = event
      @buttons = buttons
      @block = block
    end

  end

end