module Metro

  #
  # The animation is an wrapper object for an array of Gosu::Images that also contains
  # the additional information on the path, height, width, and tileability.
  #
  class Animation

    attr_accessor :images, :path, :height, :width, :tileable, :time_per_image

    def initialize(params = {})
      @images = Array(params[:images])
      @path = params[:path]
      @height = params[:height]
      @width = params[:width]
      @tileable = params[:tileable]
      @time_per_image = params[:time_per_image]
    end

    #
    # @return a hash representation of the Animation
    #
    def to_hash
      { path: path,
        width: width.to_i, height: height.to_i,
        tileable: !!tileable,
        time_per_image: time_per_image }
    end

    #
    # @return [Fixnum] the game time when the animation started to display.
    #
    def start_time
      @start_time ||= current_time
    end

    #
    # @return [Fixnum] the current time in the game.
    #
    def current_time
      Gosu::milliseconds
    end

    #
    # @return [Fixnum] the age of the animation.
    #
    def age
      current_time - start_time
    end

    #
    # @return the current animation image count.
    #
    def current_index
      age / time_per_image
    end

    #
    # @return the current animation image to display.
    #
    def current_image_index
      current_index % images.size
    end

    #
    # @return the animation is complete if it the current index exceeds the
    #   number of images.
    #
    def complete?
      current_index > (images.size - 1)
    end

    #
    # @return a Gosu::Image to be displayed in a animation sequence.
    #
    def image
      images[current_image_index]
    end

    #
    # Finds an existing image or creates a new image given the window, path,
    # width, height and tileablilty.
    #
    # @example Finding or creating an Animation image
    #
    #     Metro::Animation.find_or_create window: model.window,
    #       path: "asset_path", tileable: tileable, width: 64, height: 64,
    #       time_per_image: 50
    #
    def self.find_or_create(options)
      new options.merge(images: find_or_create_gosu_images(options))
    end

    #
    # Create an animation image given the window, path, width, height,
    #  and tileability.
    #
    # @example Creating an Animation Image
    #
    #     Metro::Animation.create window: model.window,
    #       path: "asset_path", tileable: tileable, width: 64, height: 64,
    #       time_per_image: 50
    #
    def self.create(options)
      new options.merge(images: create_gosu_images(options))
    end

    private

    def self.create_gosu_images(options)
      path = AssetPath.with(options[:path]).to_s
      images[path] = Gosu::Image.load_tiles(*create_params(options))
    end

    def self.find_or_create_gosu_images(options)
      path = AssetPath.with(options[:path]).to_s
      images[path] or create_gosu_images(options)
    end

    def self.create_params(options)
      options.symbolize_keys!
      window = options[:window]
      asset_path = AssetPath.with(options[:path]).filepath
      width = options[:width].to_i
      height = options[:height].to_i
      tileable = !!options[:tileable]
      [ window, asset_path, width, height, tileable ]
    end

    def self.images
      @images ||= {}
    end

  end
end