require_relative 'event_factory'

module Metro

  module EventDictionary
    extend self

    #
    # All defined events within this dictionary.
    #
    def events
      @events ||= HashWithIndifferentAccess.new
    end

    #
    # @example Adding a new SceneEvent to the Dictionary
    #
    #     SceneEventDictionary.add target: scene_name, type: event_type, args: args, block: block
    #
    def add(params = {})
      target = params[:target]
      event = EventFactory.new params[:type], params[:args], &params[:block]
      events[target] = events_for_target(target).push event
    end

    #
    # Return all the events for all the specified targets.
    #
    def events_for_targets(*list)
      found_events = Array(list).flatten.compact.map {|s| events_for_target(s) }.flatten.compact
      found_events
    end

    #
    # Return the events for the specified target
    #
    def events_for_target(scene_name)
      events[scene_name] ||= []
    end

    #
    # When the game is reset the event dictionary needs to flush out all of the events that it
    # has loaded as the game files will be reloaded. All metro related components will not
    # be removed as those files are not reloaded when the game is reloaded.
    #
    def reset!
      events.delete_if { |name,events| ! name.start_with? "metro/" }
    end

  end

end
