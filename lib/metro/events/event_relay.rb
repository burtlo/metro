require_relative 'event_data'

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
    # Defines the provided controls for every EventRelay that is created.
    #
    # @see #define_control
    #
    # @param [Array<ControlDefinition>] controls the definitions of controls
    #   that should be added to all EventRelays.
    #
    def self.define_controls(controls)
      controls.each { |control| define_control control }
    end

    #
    # Defines a control from a ControlDefinition for all EventRelays. A
    # control is a way of defining a shortcut for a common event. This
    # could be the use of a common set of keys for confirmation or canceling.
    #
    def self.define_control(control)
      check_for_already_defined_control!(control)

      define_method control.name do |&block|
        send(control.event,*control.args,&block)
      end
    end

    def self.check_for_already_defined_control!(control)
      if instance_methods.include? control.name
        error! "error.reserved_control_name", name: control.name
      end
    end

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
      @custom_notifications ||= HashWithIndifferentAccess.new([])
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
    #       event :on_down, GpLeft, GpUp, do: :previous_option
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
    #        event :on_down, GpLeft, GpUp do
    #         @selected_index = @selected_index - 1
    #         @selected_index = options.length - 1 if @selected_index <= -1
    #       end
    #     end
    #
    # This example uses a block instead of a method name but it is absolultey the same
    # as the last example.
    #
    def on_down(*args,&block)
      _on(@down_actions,args,block)
    end

    alias_method :button_down, :on_down

    #
    # Register for a button_up event. These events are fired when
    # the button is released (from being pressed down). This event only fires
    # once when the button moves from the pressed state to the up state.
    #
    # @example Registering for a button down event to call a method named 'next_option'
    #
    #     class ExampleScene
    #        event :on_up, KbEscape, do: :leave_scene
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
    #       event :on_up, KbEscape do
    #        transition_to :title
    #       end
    #     end
    #
    # This example uses a block instead of a method name but it is absolultey the same
    # as the last example.
    #
    def on_up(*args,&block)
      _on(@up_actions,args,block)
    end

    alias_method :button_up, :on_up

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
    #       event :on_hold KbLeft, GpLeft do
    #         player.turn_left
    #       end
    #
    #       event :on_hold, KbRight, GpRight do
    #         player.turn_right
    #       end
    #
    #       event :on_hold, KbUp, Gosu::GpButton0, do: :calculate_accleration
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

    alias_method :button_hold, :on_hold
    alias_method :button_held, :on_hold

    #
    # Register for a custom notification event. These events are fired when
    # another object within the game posts a notification with matching criteria.
    # If there has indeed been a match, then the stored action block will be fired.
    #
    # When the action block is specified is defined with no parameters it is assumed that
    # that the code should be executed within the context of the object that defined
    # the action, the 'target'.
    #
    # @example Registering for a save complete event that would re-enable a menu.
    #
    #     class ExampleScene
    #       event :notification, :save_complete do
    #         menu.enabled!
    #       end
    #     end
    #
    # The action block can also be specified with two parameters. In this case the code is
    # no longer executed within the context of the object and is instead provided the
    # the action target and the action source.
    #
    # @example Registering for a win game event that explicitly states the target and source.
    #
    #     class ExampleScene
    #
    #       event :notification, :win_game do |target,winner|
    #         target.declare_winner winner
    #       end
    #
    #       def declare_winner(winning_player)
    #         # ...
    #       end
    #     end
    #
    def notification(param,&block)
      custom_notifications[param.to_sym] = custom_notifications[param.to_sym] + [ block ]
    end

    attr_reader :up_actions, :down_actions, :held_actions, :custom_notifications

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
    def fire_button_up(id)
      execute_block_for_target( &up_action(id) )
    end

    #
    # This is called by external or parent source of events, usually a Scene, when a button down
    # event has been triggered.
    #
    def fire_button_down(id)
      execute_block_for_target( &down_action(id) )
    end

    #
    # Fire the events mapped to the held buttons within the context
    # of the specified target. This method is differently formatted because held buttons are not
    # events but polling to see if the button is still being held.
    #
    def fire_events_for_held_buttons
      held_actions.each do |key,action|
        execute_block_for_target(&action) if window and window.button_down?(key)
      end
    end
    
    def execute_block_for_target(&block)
      event_data = EventData.new(window)
      target.instance_exec(event_data,&block)
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

    #
    # Fire all events mapped to the matching notification.
    #
    def fire_events_for_notification(event,sender)
      notification_actions = custom_notifications[event]
      notification_actions.each do |action|
        _fire_event_for_notification(event,sender,action)
      end
    end

    #
    # Fire a single event based on the matched notification.
    #
    # An action without any parameters is assumed to be executed within the contexxt
    # of the target. If there are two parameters we will simply execute the action and
    # pass it both the target and the sender.
    #
    # @TODO: Allow for the blocks to be specified with one parameter: source (and executed
    #   within the context of the target)
    #
    # @TODO: Allow for the blocks to be specified with three parameters: source, target, event
    #
    def _fire_event_for_notification(event,sender,action)
      if action.arity == 2
        action.call(target,sender)
      else
        target.instance_eval(&action)
      end
    end

  end
end