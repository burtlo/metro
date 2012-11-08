module Metro
  class Model

    #
    # A color property maintains a Gosu::Color.
    #
    # A color property also defines an alpha property which allows a more direct interface
    # to setting the alpha property on the color. This is useful in cases for images where
    # the color remains as white but the alpha value needs to be adjusted.
    #
    # A color is stored in the properties as a string representation and is converted into
    # a Gosu::Color when it is retrieved within the system.
    #
    # @example Defining a color property using the color properties default
    #
    #     class Hero < Metro::Model
    #       property :color
    #
    #       def draw
    #         image.draw x, y, z_order, x_factor, y_factor, color, :add)
    #       end
    #
    #     end
    #
    # @example Defining a color property providing a default
    #
    #     class Hero < Metro::Model
    #       property :color, default: "rgba(255,0,0,1.0)"
    #     end
    #
    # @example Using the alpha property
    #
    #     class Hero < Metro::Model
    #       property :color, default: "rgba(255,0,0,1.0)"
    #
    #       def become_ghost!
    #         self.alpha = 127
    #       end
    #     end
    #
    # @example Using a color property with a different property name
    #
    #     class Hero < Metro::Model
    #       property :color
    #       property :invincible_color, type: :color, default: "rgba(255,0,255,1.0)"
    #
    #       def draw
    #         if invincible?
    #           image.draw x, y, z_order, x_factor, y_factor, invincible_color, :add)
    #         else
    #           image.draw x, y, z_order, x_factor, y_factor, color, :add)
    #         end
    #       end
    #     end
    #
    class ColorProperty < Property

      define_property :alpha
      define_property :red
      define_property :green
      define_property :blue

      # By default convert the value to the default color if it
      # cannot be processed by the other get filters.
      get do |value|
        default_color
      end

      # A color should remain a color.
      get Gosu::Color do |value|
        value
      end

      # A string representation of a color will be converted to a color.
      # If Gosu::Color does not support the format, then it will default to white.
      get String do |value|
        create_color value
      end

      # By default save the default color string.
      set do |value|
        default_color_string
      end

      # When given a string assume that it is a string representation of color.
      set String do |value|
        value
      end

      # When given a color, convert it into the string representation.
      set Gosu::Color do |value|
        value.to_s
      end

      #
      # @return the default color of the color property. This can be set during initialization
      #   by usign the option `default`.
      #
      def default_color
        create_color(default_color_string)
      end

      private

      def default_color_string
        options[:default] || "rgba(255,255,255,1.0)"
      end

      def create_color(value)
        Gosu::Color.new value
      end

    end

  end
end