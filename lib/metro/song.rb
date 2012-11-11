module Metro

  #
  # Song is a wrapper class for a Gosu Song. This allows for additional data to be stored
  # without relying on monkey-patching on functionality.
  #
  class Song < SimpleDelegator

    attr_accessor :song, :path

    def initialize(song,path)
      super(song)
      @song = song
      @path = path
    end

    #
    # Finds an existing song or creates a new song given the window and path.
    #
    # @example Finding or creating an Song
    #
    #     Metro::Image.find_or_create window: model.window, path: "asset_path"
    #
    def self.find_or_create(options)
      path = AssetPath.with(options[:path])
      songs[path.to_s] or (songs[path.to_s] = create(options))
    end

    #
    # Create an Song given the window and path.
    #
    # @example Creating an Song
    #
    #     Metro::Song.create window: model.window, path: "asset_path"
    #
    def self.create(options)
      window, asset_path = create_params(options)
      gosu_song = Gosu::Song.new(window,asset_path.filepath)
      new gosu_song, asset_path.path
    end

    private

    def self.create_params(options)
      options.symbolize_keys!
      asset_path = AssetPath.with(options[:path])
      window = options[:window]
      [ window, asset_path ]
    end

    def self.songs
      @songs ||= {}
    end

  end
end
