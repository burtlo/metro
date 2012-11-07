module Metro

  #
  # The animation is an wrapper object for an array of Gosu::Images that also contains
  # the additional information on the path, height, width, and tileability.
  #
  class Animation

    attr_accessor :images, :path, :height, :width, :tileable

    def initialize(params = {})
      @images = Array(params[:images])
      @path = params[:path]
      @height = params[:height]
      @width = params[:width]
      @tileable = params[:tileable]
    end

    def to_hash
      { path: path, width: width.to_i, height: height.to_i, tileable: !!tileable }
    end

    #
    # @return a Gosu::Image to be displayed in a animation sequence.
    #
    def image
      images[Gosu::milliseconds / 100 % images.size]
    end

  end
end