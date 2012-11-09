module Metro

  #
  # Image is a wrapper class for a Gosu Image. This allows for additional data to be stored
  # without relying on monkey-patching on functionality.
  #
  class Image < SimpleDelegator

    #
    # Generate an image given the Gosu window and path. Consider using a model and an image
    # property instead of using this method.
    #
    # @note this goes through the image property because that current performs the caching.
    #
    # @example Creating an Image
    #
    #     Metro::Image.create path: "relative_imagepath.png", window: window
    #
    # @see Metro::Model::ImageProperty
    #
    def self.create(params = {})
      Model::ImageProperty.image_for params
    end

    def initialize(gosu_image,path,tileable)
      super(gosu_image)
      @path = path
      @tileable = tileable
    end

    # The relative path of the image
    attr_reader :path

    # The tileability of the image
    attr_reader :tileable

    def dimensions
      Metro::Units::Dimensions.of width, height
    end

  end
end