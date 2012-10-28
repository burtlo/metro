module Metro

  #
  # The GosuEvents module creates aliases for the Keyboard and the Gamepad events
  # within the Gosu Namespace. This is so Metro can use the events without requiring
  # the namespace.
  #
  # This makes the interface of these events more portable.
  #
  module GosuConstants

    def self.extended(base)
      add constants: keyboard_events, to: base
      add constants: gamepad_events, to: base
      add constants: mouse_events, to: base
    end

    #
    # @return the constant from which to search for all the other constants.
    #   This helper method is to to save sprinkling the constant value
    #   throughout the rest of the module.
    def self.gosu
      Gosu
    end

    def self.keyboard_events
      find_all_constants_with_prefix "Kb"
    end

    def self.gamepad_events
      find_all_constants_with_prefix "Gp"
    end

    def self.mouse_events
      find_all_constants_with_prefix "Ms"
    end

    def self.find_all_constants_with_prefix(prefix)
      gosu.constants.find_all { |c| c.to_s.start_with? prefix }
    end

    #
    # Alias the list of given constants within the given class.
    #
    def self.add(options={})
      events = options[:constants]
      target = options[:to]

      events.each {|event| target.const_set event, gosu.const_get(event) }
    end

  end
end