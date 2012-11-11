module Metro

  #
  # Sample is a wrapper class for a Gosu Sample. This allows for additional data to be stored
  # without relying on monkey-patching on functionality.
  #
  class Sample < SimpleDelegator

    attr_accessor :sample, :path

    def initialize(sample,path)
      super(sample)
      @sample = sample
      @path = path
    end

    #
    # Create a sample given the window and path.
    #
    # @example Creating a Sample
    #
    #     Metro::Sample.create window: model.window, path: "sample_path.wav"
    #
    def self.create(options)
      window, asset_path = create_params(options)
      gosu_sample = Gosu::Sample.new(window,asset_path.filepath)
      new gosu_sample, asset_path.path
    end

    private

    def self.create_params(options)
      options.symbolize_keys!
      asset_path = AssetPath.with(options[:path])
      window = options[:window]
      [ window, asset_path ]
    end

  end
end
