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

    def self.modifier_key_list_names
      @modifier_key_list_names ||= %w[ KbLeftControl KbRightControl
                                        KbLeftAlt KbRightAlt
                                        KbLeftMeta KbRightMeta
                                        KbLeftShift KbRightShift ]
    end
    
    def self.modifier_key_list
      @modifier_key_list ||= modifier_key_list_names.map {|key| "Gosu::#{key}".constantize }
    end

    modifier_key_list_names.each_with_index do |key_name,index|
      define_method "#{key_name.gsub(/^Kb/,'').underscore}?" do
        modifier_keys[self.class.modifier_key_list[index]]
      end
    end

  end
end