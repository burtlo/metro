module Metro

  class Song < SimpleDelegator

    attr_accessor :song, :path

    def initialize(song,path)
      super(song)
      @song = song
      @path = path
    end

  end
end
