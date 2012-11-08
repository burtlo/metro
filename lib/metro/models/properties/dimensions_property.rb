module Metro
  class Model

    #
    # A dimensions property maintains an width and height.
    #
    # A dimensions property also defines a `width` property and a `height`
    # property which allows a more direct interface. Changing these values
    # will update the dimensions the next time that it is drawn.
    #
    # Dimensions is stored in the properties as a string and is converted into
    # a Dimensions when it is retrieved within the system. When retrieving the dimensions.
    #
    # @example Defining a dimensions property
    #
    #     class Hero < Metro::Model
    #       property :dimensions
    #     end
    #
    # @example Defining a dimensions providing a default
    #
    #     class Hero < Metro::Model
    #       property :dimensions, default: Dimensions.of 100.0, 100.0
    #     end
    #
    # @example Using a dimensions property with a different property name
    #
    #     class Hero < Metro::Model
    #       property :box, type: dimensions, default: Dimensions.of 100.0, 100.0
    #       # box_width, box_height
    #     end
    #
    class DimensionsProperty < Property

      define_property :width

      define_property :height

      get do |value|
        default_dimensions
      end

      get String do |value|
        Dimensions.parse(value)
      end

      set do |value|
        default_dimensions.to_s
      end

      set String do |value|
        value
      end

      set Dimensions do |value|
        value.to_s
      end

      def default_dimensions
        (options[:default] and options[:default].is_a? Dimensions) ? options[:default] : Dimensions.none
      end

    end

  end
end
