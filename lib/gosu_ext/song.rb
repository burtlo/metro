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

  end
end
