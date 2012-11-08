module Metro
  class Model

    #
    # A position property maintains a 2D Point.
    #
    # A position property also defines an `x` property and a `y` property which allows a
    # more direct interface.
    #
    # A position is stored as a string in the properties and retrieved as a Point object.
    #
    # @example Defining a position property, using the x, y and z_order properties
    #
    #     class Enemy < Metro::Model
    #       property :position
    #
    #       def draw
    #         # image.draw position.x, position.y, z_order, x_factor, y_factor, color, :add)
    #         image.draw x, y, z_order, x_factor, y_factor, color, :add)
    #       end
    #     end
    #
    # @example Defining a position property providing a default
    #
    #     class Enemy < Metro::Model
    #       property :position, default: Point.at(44,66)
    #     end
    #
    # @example Using a position property with a different property name
    #
    #     class Hero < Metro::Model
    #       property :pos, type: :position, default: Point.zero
    #
    #       def draw
    #         # image.draw pos.x, pos.y, pos.z_order, x_factor, y_factor, color, :add)
    #         image.draw pos_x, pos_y, pos_z_order, x_factor, y_factor, color, :add)
    #       end
    #     end
    #
    class PositionProperty < Property

      # Define an x position property
      define_property :x

      # Define a y position property
      define_property :y

      # Define a z position property which is used for the z order
      define_property :z
      define_property :z_order

      # When no getters match the specified value return the default point
      get do
        default_point
      end

      # When getting a point, then simply send that point on. This is often
      # the case when the property is initailized by a scene.
      get Point do |point|
        point
      end

      # When getting a string convert it to a point.
      get String do |value|
        Point.parse(value)
      end

      # When no setters match save the default point.
      set do
        default_point.to_s
      end

      # When given a string, it is assumed to be a well formated point
      set String do |value|
        Point.parse(value).to_s
      end

      # When given a point save the the string value of it.
      set Point do |value|
        value.to_s
      end

      def default_point
        (options[:default] and options[:default].is_a? Point) ? options[:default] : Point.zero
      end

    end

  end
end
