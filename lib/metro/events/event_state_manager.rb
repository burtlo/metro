module Metro

  class EventStateManager
    def initialize
      @current_state = []
    end

    attr_reader :current_state

    #
    # Clear all the event relays of the current game state
    #
    def clear
      current_state.clear
    end

    #
    # Fire events for held buttons within the current game state
    #
    def fire_events_for_held_buttons
      current_state.each {|cs| cs.fire_events_for_held_buttons }
    end

    #
    # Fire events for button up for the current game state
    #
    def fire_button_up(id)
      current_state.each {|cs| cs.fire_button_up(id) }
    end

    #
    # Fire events for button down within the current game state
    #
    def fire_button_down(id)
      current_state.each {|cs| cs.fire_button_down(id) }
    end

    #
    # Fire notification events within the current game state
    #
    def fire_events_for_notification(event,sender)
      current_state.each {|cs| cs.fire_events_for_notification(event,sender) }
    end

    #
    # An an event relay to the current game state
    #
    def push(relay)
      current_state.push relay
    end
  end

end