module Metro
  class Model

    #
    # A scale property maintains an x and y scaling factor.
    #
    # A scale property also defines a `x_factor` property and a `y_factor`
    # property which allows a more direct interface. Changing these values will
    # update the scale the next time that it is used.
    #
    # A scale is stored in the properties as a string representation and is
    # converted into a Scale when it is retrieved within the system.
    #
    # @example Defining a scale property
    #
    #     class Scoreboard < Metro::Model
    #       property :font
    #       property :color
    #       property :scale
    #
    #       def draw
    #         image.draw text, x, y, z_order, x_factor, y_factor, color
    #       end
    #
    #     end
    #
    # @example Defining a scale property providing a default
    #
    #     class Hero < Metro::Model
    #       property :image, path: 'hero.jpg'
    #       property :scale, default: "1.0,1.0"
    #     end
    #
    # @example Using a scale property with a different property name
    #
    #     class Hero < Metro::Model
    #       property :image, path: 'hero.jpg'
    #       property :enraged_scale, type: :scale, default: "4.0,4.0"
    #       property :angle
    #       property :color
    #
    #       def draw
    #         image.draw_rot x, y, z_order, angle.to_f, 0.5, 0.5, 
    #           enraged_scale_factor_x, enraged_scale_factor_y, color
    #       end
    #     end
    #
    class ScaleProperty < Property
      define_property :x_factor

      define_property :y_factor

      get do |value|
        default_scale
      end

      get String do |value|
        Scale.parse(value)
      end

      set do |value|
        default_scale.to_s
      end

      set String do |value|
        value
      end

      set Scale do |value|
        value.to_s
      end

      def default_scale
        (options[:default] and options[:default].is_a? Scale) ? options[:default] : Scale.one
      end

    end

  end
end
