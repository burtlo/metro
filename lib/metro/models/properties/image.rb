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
    # @example Defining an image property providing a default
    #
    #     class Player < Metro::Model
    #       property :image, default: "player.png"
    #     end
    #
    # @example Using an image property with a different property name
    #
    #     class Player < Metro::Model
    #       property :disconnected_image, type: :image, default: "disconnected_player.png"
    #
    #       def draw
    #         disconnected_image.draw x, y, z_order, x_factor, y_factor, color, :add)
    #       end
    #     end
    #
    class ImageProperty < Property

      # Return the image at the specified path.
      # @note The path should be the relative path within the game.
      get String do |path|
        self.class.image_for_path path: path, window: model.window
      end

      # Set the image with the specified path.
      # @note The path should be the relative path within the game.
      set String do |path|
        path
      end

      # Set the image with the given image. A Gosu::Image does not normally
      # store it's path, however, this functionality has been monkey-patched.
      set Gosu::Image do |image|
        image.path
      end

      #
      # Return an image for the specified path. On first request it will be loaded from
      # the file-system. On subsequent requests it will be pulled from the cache.
      #
      # @param [Hash] options the relative `path` to the image and the window for which it
      #   will be displayed.
      #
      def self.image_for_path(options)
        options.symbolize_keys!
        path = options[:path]
        window = options[:window]

        image = images[path]
        unless image
          image = create_image(window,path,false)
          images[path] = image
        end

        image
      end

      def self.images
        @images ||= {}
      end

      private

      # @TODO The Gosu::Image creation should automatically perform this operation of saving the path
      #   to the image. This should be monkey-patched onto the image so that images created outside
      #   of this process will also have a specified path.
      def self.create_image(window,path,tileable)
        image = Gosu::Image.new(window,asset_path(path),tileable)
        image.path = path
        image
      end

    end

  end
end