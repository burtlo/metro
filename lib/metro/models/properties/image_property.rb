module Metro
  class Model

    #
    # A image property maintains a Gosu::Image.
    #
    # An image is stored in the properties as a string to the specified image path and is converted into
    # a Gosu::Image when it is retrieved within the system. When retrieving an image the Image
    # Property will attempt to use a image at that path that already meets that criteria if it has been
    # loaded.
    #
    # The images are cached within the image property to help performance by reducing the unncessary
    # creation of similar images.
    #
    # @example Defining a image property
    #
    #     class Player < Metro::Model
    #       property :image
    #
    #       def draw
    #         image.draw x, y, z_order, x_factor, y_factor, color, :add)
    #       end
    #
    #     end
    #
    # @example Defining an image property providing a path
    #
    #     class Player < Metro::Model
    #       property :image, path: "player.png"
    #     end
    #
    # @example Using an image property with a different property name
    #
    #     class Player < Metro::Model
    #       property :disconnected_image, type: :image, path: "disconnected_player.png"
    #
    #       def draw
    #         disconnected_image.draw x, y, z_order, x_factor, y_factor, color, :add)
    #       end
    #     end
    #
    class ImageProperty < Property

      get do
        default_image
      end

      # Return the image at the specified path.
      # @note The path should be the relative path within the game.
      get String do |path|
        self.class.image_for path: path, window: model.window
      end

      set do
        default_image.path
      end

      # Set the image with the specified path.
      # @note The path should be the relative path within the game.
      set String do |path|
        path
      end

      # Set the image with the given image. A Gosu::Image does not normally
      # store it's path, however, this functionality has been monkey-patched.
      set Metro::Image do |image|
        image.path
      end

      def default_image
        self.class.image_for path: default_image_path, window: model.window
      end

      def default_image_path
        options[:path] || metro_asset_path("missing.png")
      end


      #
      # Return an image for the specified path. On first request it will be loaded from
      # the file-system. On subsequent requests it will be pulled from the cache.
      #
      # @param [Hash] options the relative `path` to the image and the window for which it
      #   will be displayed.
      #
      def self.image_for(options)
        options.symbolize_keys!

        absolute_path = path = options[:path]
        absolute_path = asset_path(absolute_path) unless absolute_path.start_with? "/"

        tileable = !!options[:tileable]
        window = options[:window]

        gosu_image = images[path]
        unless gosu_image
          gosu_image = create_image(window,absolute_path,tileable)
          images[path] = gosu_image
        end

        Metro::Image.new gosu_image, path, tileable
      end

      def self.images
        @images ||= {}
      end

      private

      def self.create_image(window,path,tileable)
        Gosu::Image.new(window,path,tileable)
      end

    end

  end
end