module Metro
  class Model

    #
    # A song property maintains a Gosu::Song.
    #
    # A song is stored in the properties as the path in the assets folder and is converted into
    # a Gosu::Song when it is retrieved within the system. When retrieving a song the Song
    # Property will attempt to use a song that already exists that meets that criteria.
    #
    # The songs are cached within the song property to help performance by reducing the unncessary
    # creation of similar song.
    #
    # @example Defining a song property
    #
    #     class Song < Metro::Model
    #       property :song
    #     end
    #
    # @example Defining a song property providing a default
    #
    #     class Song < Metro::Model
    #       property :song, path: 'happy-song.wav'
    #     end
    #
    # @example Using a song property with a different property name
    #
    #     class Song < Metro::Model
    #       property :intro, type: :song, path: 'intro-song.wav'
    #     end
    #
    class SongProperty < Metro::Model::Property

      # By default, getting an unsupported value will return the default song
      get do |value|
        default_song
      end

      # By default, setting an unsupported value will save the default song
      set do |value|
        default_song_name
      end

      # Generate a song from the specified string filepath
      get String do |filename|
        self.class.song_for path: filename, window: model.window
      end

      # The assumption here is that the string is a song filepath
      set String do |filename|
        filename
      end

      # Setting the song value with a Metro::Song will save the string filepath
      set Metro::Song do |song|
        song.path
      end

      #
      # @return the default song for the song property. This is based on the default
      #   song name.
      #
      def default_song
        self.class.song_for path: default_song_name, window: model.window
      end

      #
      # @return a string song name that is default. If the property was not created with
      #   a default value the the default song is the missing song found in Metro.
      #
      def default_song_name
        options[:path] or 'missing.ogg'
      end

      #
      # Returns a Metro::Song. This is composed of the metadata provided and a Gosu::Song.
      #
      # Songs are cached within the property to increase performance.
      #
      # @param [Hash] options the path, window, and other parameters necessary to generate
      #   a song.
      #
      def self.song_for(options)
        Song.find_or_create(options)
      end

    end
  end
end