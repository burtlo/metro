module Metro
  class EventData

    attr_reader :mouse_x, :mouse_y, :created_at

    def initialize(window)
      @created_at = Time.now
      @mouse_x = window.mouse_x
      @mouse_y = window.mouse_y

      capture_modifier_keys(window)
    end

    def modifier_keys
      @modifier_keys ||= {}
    end

    def capture_modifier_keys(window)
      self.class.modifier_key_list.each do |key|
        modifier_keys[key] = window.button_down?(key)
      end
    end

    #
    # TODO: This attempt to reduce duplication is brittle and will likely end in heartache.
    # 

    def self.modifier_key_list_names
      @modifier_key_list_names ||= %w[ KbLeftControl KbRightControl
                                        KbLeftAlt KbRightAlt
                                        KbLeftMeta KbRightMeta
                                        KbLeftShift KbRightShift ]
    end

    def self.modifier_key_list
      @modifier_key_list ||= modifier_key_list_names.map {|key| "Gosu::#{key}".constantize }
    end

    #
    # Generate methods for each left and right modifier key
    #

    modifier_key_list_names.each_with_index do |key_name,index|
      define_method "#{key_name.gsub(/^Kb/,'').underscore}?" do
        modifier_keys[self.class.modifier_key_list[index]]
      end
    end

    #
    # Define generic modifier keys that is not concerned with whether it
    # was the left key or the right key.
    #

    [ :control?, :alt?, :meta?, :shift? ].each do |generic|
      define_method generic do
        send("left_#{generic}") or send("right_#{generic}")
      end
    end

  end
end