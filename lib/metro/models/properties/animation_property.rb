module Metro
  class Model

    #
    # A animation property manages an Animation, which is an array of Gosu::Images,
    # and some metadata.
    #
    # @see Animation
    #
    # A animation is stored in the properties as a hash representation and is
    # converted into an Animation when it is retrieved within the system.
    #
    # The animate images are cached within the animation property to help
    # performance by reducing the unncessary creation of similar animations.
    #
    # @example Defining an animation property (will default to the missing animation)
    #
    #     class Scoreboard < Metro::Model
    #       property :animation
    #
    #       def draw
    #         animation.image.draw text, x, y, z_order, x_factor, y_factor, color
    #       end
    #     end
    #
    # @example Defining an animation with a path.
    #
    #     class Hero < Metro::Model
    #       property :animation, path: "star.png", dimensions: Dimensions.of(25,25)
    #         dimensions: Dimensions.of(25,25) }
    #
    #       def draw
    #         animation.image.draw text, x, y, z_order, x_factor, y_factor, color
    #       end
    #     end
    #
    # @example Using an animation property with a different property name
    #
    #     class Hero < Metro::Model
    #       property :walking, type: :animation, path: "star.png",
    #         dimensions: Dimensions.of(25,25)
    #
    #       def draw
    #         walking.image.draw text, x, y, z_order, x_factor, y_factor, color
    #       end
    #     end
    #
    class AnimationProperty < Property

      # By default return the default animation when getting a nil or
      # other unsupported value.
      get do
        create_animation default_properties
      end

      # When getting a hash, create the animation with the properties.
      get Hash do |loaded|
        create_animation default_properties.merge(loaded)
      end

      # Setting the animation with a nil or other unsupported value
      # will default to the default animation.
      set do
        defaults.except(:window)
      end

      # Setting with an animation will convert it to it's hash representation.
      set Animation do |image|
        image.to_hash
      end

      # Setting with a hash will assume the hash defines an animation.
      set Hash, HashWithIndifferentAccess do |value|
        value.except(:window)
      end

      private
      
      def create_animation(properties)
        self.class.animation_for properties
      end

      def default_properties
        { window: model.window,
          path: default_image_filename,
          width: default_dimensions.width,
          height: default_dimensions.height,
          time_per_image: default_time_per_image,
          tileable: false }
      end

      def default_image_filename
        options[:path] or "missing_animation.png"
      end

      def default_dimensions
        options[:dimensions] or Dimensions.of(16.0,16.0)
      end

      def default_time_per_image
        options[:time_per_image] or 50
      end

      def self.animation_for(options)
        Metro::Animation.find_or_create(options)
      end

    end

  end
end