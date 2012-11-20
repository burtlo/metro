module Metro

  #
  # Font is a wrapper class for a Gosu::Font. This allows for additional data 
  # to be stored without relying on monkey-patching on functionality.
  #
  class Font < SimpleDelegator

    def initialize(gosu_font)
      super(gosu_font)
    end

    #
    # Return a font that matches the specified criteria. Using the name, size, 
    # and window a font will be generated or retrieved from the cache.
    #
    # @param [Hash] value the hash that contains the `name`, `size` and `window` 
    # that describe the font.
    #
    def self.find_or_create(options)
      window, name, size = create_params(options)
      gosu_font = fonts["#{name}:#{size}:#{window}"]
      gosu_font ? new(gosu_font) : create(options)
    end

    def self.create(options)
      window, name, size = create_params(options)
      gosu_font = create_gosu_font(window,name,size)
      fonts["#{name}:#{size}:#{window}"] = gosu_font
      new(gosu_font)
    end

    def self.create_gosu_font(window, name, size)
      Gosu::Font.new window, name, size
    end

    private

    def self.create_params(options)
      options.symbolize_keys!
      [ options[:window], options[:name], options[:size] ]
    end

    def self.fonts
      @fonts ||= {}
    end

  end
end