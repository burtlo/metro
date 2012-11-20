module Metro
  class Model

    #
    # A font property maintains a Gosu::Font.
    #
    # A font property also defines a `font_size` property and a `font_name` property which allows a
    # more direct interface. Changing these values will update the font the next time that it is drawn.
    #
    # A font is stored in the properties as a hash representation and is converted into
    # a Gosu::Font when it is retrieved within the system. When retrieving a font the Font
    # Property will attempt to use a font that already exists that meets that criteria.
    #
    # The fonts are cached within the font property to help performance by reducing the unncessary
    # creation of similar fonts.
    #
    # @example Defining a font property
    #
    #     class Scoreboard < Metro::Model
    #       property :font
    #
    #       def draw
    #         font.draw text, x, y, z_order, x_factor, y_factor, color
    #       end
    #
    #     end
    #
    # @example Defining a font property providing a default
    #
    #     class Hero < Metro::Model
    #       property :font, default: { name: 'Comic Sans', size: 80 }
    #     end
    #
    # @example Using the `font_size` and `font_name` properties
    #
    #     class Hero < Metro::Model
    #       property :color, default: "rgba(255,0,0,1.0)"
    #
    #       def dignified
    #         self.font_size = 45
    #         self.font_name = 'Helvetica'
    #       end
    #     end
    #
    # @example Using a font property with a different property name
    #
    #     class Hero < Metro::Model
    #       property :alt_font, type: :font, default: "rgba(255,0,255,1.0)"
    #
    #       def draw
    #         puts "Font: #{alt_font_name}:#{alt_font_size}"
    #         alt_font.draw text, x, y, z_order, x_factor, y_factor, color
    #       end
    #     end
    #
    class FontProperty < Property

      # Define a paired property which allows the setting of the font size
      define_property :size, prefix: true
      # Define a paired property which allows the setting of the font name
      define_property :name, type: :text, prefix: true

      # Return the default font when the value is not supported.
      get do
        default_font
      end

      # Create a font from the specified hash of data.
      #
      # @example Format of Hash
      #
      #     { name: 'Times New Roman', size: 33 }
      #
      get Hash do |value|
        self.class.font_for value.merge(window: model.window)
      end

      # Save a hash of the default font when the value is not supported.
      set do
        { name: default_font_name, size: default_font_size }
      end

      # Save a hash representation of the font when given a font
      set Metro::Font do |font|
        { name: font.name, size: font.height }
      end

      # Save the hash provided. It is assumed to contain the correct font data.
      set Hash, HashWithIndifferentAccess do |hash|
        hash.to_hash
      end

      #
      # @return the default font to use when a value has not been provided.
      #
      def default_font
        self.class.font_for name: default_font_name,
          size: default_font_size,
          window: model.window
      end

      #
      # Use the specified default font size or fall back to 40.
      #
      def default_font_size
        (options[:default] and options[:default][:size]) ? options[:default][:size] : 40
      end

      #
      # Use the specified default font name or fall back to Gosu's default font name.
      #
      def default_font_name
        (options[:default] and options[:default][:name]) ? options[:default][:name] : Gosu::default_font_name
      end

      #
      # Return a font that matches the specified criteria. Usig the name, size, and window a font will be
      # generated or retrieved from the cache.
      #
      # @param [Hash] value the hash that contains the `name`, `size` and `window` that describe the font.
      #
      def self.font_for(value)
        Font.find_or_create(value)
      end

    end

  end
end
