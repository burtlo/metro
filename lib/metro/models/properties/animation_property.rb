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
    #         dimensions: Metro::Dimensions.of(25,25) }
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
    #         dimensions: Metro::Dimensions.of(25,25)
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
        default_animation
      end

      # When getting a hash, create the animation with the properties.
      get Hash do |value|
        self.class.animation_for value.merge(window: model.window)
      end

      # Setting the animation with a nil or other unsupported value
      # will default to the default animation.
      set do
        default_animation.to_hash
      end

      # Setting with an animation will convert it to it's hash representation.
      set Animation do |image|
        image.to_hash
      end

      # Setting with a hash will assume the hash defines an animation.
      set Hash do |value|
        value
      end

      def default_animation
        self.class.animation_for window: model.window,
          path: default_image_path,
          width: default_dimensions.width,
          height: default_dimensions.height,
          tileable: false
      end

      def default_image_path
        options[:path] ? options[:path] : metro_asset_path("missing_animation.png")
      end

      def default_dimensions
        options[:dimensions] ? options[:dimensions] : Dimensions.of(16.0,16.0)
      end

      #
      # Return an animation for the specified path. On first request it will be loaded from
      # the file-system. On subsequent requests it will be pulled from the cache.
      #
      # @param [Hash] options the relative `path` to the image and the window for which it
      #   will be displayed.
      #
      def self.animation_for(options)
        options.symbolize_keys!
        window = options[:window]

        absolute_path = path = options[:path]
        absolute_path = asset_path(absolute_path) unless absolute_path.start_with? "/"

        width = options[:width].to_i
        height = options[:height].to_i
        tileable = options[:tileable]

        animation_images = images[path]
        unless animation_images
          animation_images = create_images(window,absolute_path,width,height,tileable)
          images[path] = animation_images
        end

        Animation.new options.merge(images: animation_images)
      end

      def self.images
        @images ||= {}
      end

      private

      def self.create_images(window,path,width,height,tileable)
        Gosu::Image.load_tiles(window,path,width,height,tileable)
      end

    end

  end
end