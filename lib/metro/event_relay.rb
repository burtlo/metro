module Metro

  #
  # An EventRelay represents a target's willingness to respond to events
  # generate from the window. An event relay is generate for every scene
  # but additional relays can be generated to also listen for events.
  #
  # An event relay can register a target to listen for the following window
  # events: 'button_down'; 'button_up'; and 'button_held'.
  #
  # @note registering for 'button_held' events require that the window be
  #   speicfied. As that is the only way to ask if the button is currently
  #   pressed.
  #
  # @see #on_up
  # @see #on_down
  # @see #on_hold
  #
  # A target can also receive events when 'button_up' and 'button_down' events
  # have been fired but did not map to any specified actions. This is similar to
  # Ruby's {#method_missing}.
  #
  # To receive unampped 'button_up' events define a method
  # named `up_action_missing(id)` within your target.
  #
  # To receive unampped 'button_down' events define a method
  # named `down_action_missing(id)` within your target.
  #
  # @example Scene that receives all the 'button_up' and 'button_down' events that
  #   are not mapped to actions.
  #
  #     class ExampleScene
  #       def up_action_missing(id)
  #         puts "No up action found for #{id}"
  #       end
  #
  #       def down_action_missing(id)
  #         puts "No down action found for #{id}"
  #       end
  #     end
  #
  class EventRelay

    #
    # An event relay is created a with a target and optionally a window.
    #
    # @param [Object] target the object that will execute the code when
    #   the button events have fired have been triggered.
    # @param [Window] window the window of the game. This parameter is
    #   optional and only required if the events are interested in buttons
    #   being held.
    #
    def initialize(target,window = nil)
      @target = target
      @window = window
      @up_actions ||= {}
      @down_actions ||= {}
      @held_actions ||= {}
    end

    attr_reader :target, :window

    #
    # Register for a button_down event. These events are fired when
    # the button is pressed down. This event only fires once when the
    # button moves from the not pressed to the down state.
    #
    # @example Registering for a button down event to call a method named 'previous_option'
    #
    #     class ExampleScene
    #       def events(e)
    #         e.on_down Gosu::GpLeft, Gosu::GpUp, do: :previous_option
    #       end
    #
    #       def previous_option
    #         @selected_index = @selected_index - 1
    #         @selected_index = options.length - 1 if @selected_index <= -1
    #       end
    #     end
    #
    # Here in this scene if the GpLeft or GpUp buttons are pressed down the method
    # `previous_options` will be executed.
    #
    #
    # @example Registering for a button down event with a block of code to execute
    #
    #     class ExampleScene
    #       def events(e)
    #         e.on_down Gosu::GpLeft, Gosu::GpUp do
    #           @selected_index = @selected_index - 1
    #           @selected_index = options.length - 1 if @selected_index <= -1
    #         end
    #       end
    #     end
    #
    # This example uses a block instead of a method name but it is absolultey the same
    # as the last example.
    #
    def on_down(*args,&block)
      _on(@down_actions,args,block)
    end

    #
    # Register for a button_up event. These events are fired when
    # the button is released (from being pressed down). This event only fires
    # once when the button moves from the pressed state to the up state.
    #
    # @example Registering for a button down event to call a method named 'next_option'
    #
    #     class ExampleScene
    #       def events(e)
    #         e.on_up Gosu::KbEscape, do: :leave_scene
    #       end
    #
    #       def leave_scene
    #         transition_to :title
    #       end
    #     end
    #
    # Here in this scene if the Escape Key is pressed and released the example scene
    # will transition to the title scene.
    #
    # @example Registering for a button up event with a block of code to execute
    #
    #     class ExampleScene
    #       def events(e)
    #         e.on_up Gosu::KbEscape do
    #           transition_to :title
    #         end
    #       end
    #     end
    #
    # This example uses a block instead of a method name but it is absolultey the same
    # as the last example.
    #
    def on_up(*args,&block)
      _on(@up_actions,args,block)
    end

    #
    # Register for a button_held event. These events are fired when
    # the button is currently in the downstate. This event continues to fire at the
    # beginning of every update of a scene until the button is released.
    #
    # @note button_held events require that the window be specified during initialization.
    #
    # @example Registering for button held events
    #
    #     class ExampleScene
    #       def events(e)
    #         e.on_hold Gosu::KbLeft, Gosu::GpLeft do
    #           player.turn_left
    #         end
    #
    #         e.on_hold Gosu::KbRight, Gosu::GpRight do
    #           player.turn_right
    #         end
    #
    #         e.on_hold Gosu::KbUp, Gosu::GpButton0, do: :calculate_accleration
    #       end
    #
    #       def calculate_acceleration
    #         long_complicated_calculated_result = 0
    #         # ... multi-line calculations to determine the player acceleration ...
    #         player.accelerate = long_complicated_calculated_result
    #       end
    #     end
    #
    def on_hold(*args,&block)
      log.warn "Registering for a on_hold event requires that a window be provided." unless window
      _on(@held_actions,args,block)
    end

    attr_reader :up_actions, :down_actions, :held_actions

    def _on(hash,args,block)
      options = (args.last.is_a?(Hash) ? args.pop : {})

      args.each do |keystroke|
        hash[keystroke] = block || lambda { |instance| send(options[:do]) }
      end
    end

    #
    # This is called by external or parent source of events, usually a Scene, when a button up event
    # has been triggered.
    #
    def button_up(id)
      target.instance_eval( &up_action(id) )
    end

    #
    # This is called by external or parent source of events, usually a Scene, when a button down
    # event has been triggered.
    #
    def button_down(id)
      target.instance_eval( &down_action(id) )
    end

    #
    # Fire the events mapped to the held buttons within the context
    # of the specified target. This method is differently formatted because held buttons are not
    # events but polling to see if the button is still being held.
    #
    def fire_events_for_held_buttons
      held_actions.each do |key,action|
        target.instance_eval(&action) if window and window.button_down?(key)
      end
    end

    # @return a block of code that is mapped for the 'button_up' id or a block that will attempt to call out
    #   to the action missing method.
    def up_action(id)
      up_actions[id] || lambda {|instance| send(:up_action_missing,id) if respond_to?(:up_action_missing) }
    end

    # @return a block of code that is mapped for the 'button_down' id or a block that will attempt to call out
    #   to the action missing method.
    def down_action(id)
      down_actions[id] || lambda {|instance| send(:down_action_missing,id) if respond_to?(:down_action_missing) }
    end


  end
end