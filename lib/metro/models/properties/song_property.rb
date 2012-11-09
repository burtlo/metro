module Metro
  class Model
    class SongProperty < Metro::Model::Property

      get_or_set do |value|
        raise "No song file specified #{value} #{value.class}"
      end

      get String do |filename|
        self.class.song_for path: filename, window: model.window
      end

      set String do |filename|
        filename
      end

      set Metro::Song do |song|
        song.path
      end

      def self.song_for(options)
        options.symbolize_keys!
        relative_path = options[:path]
        window = options[:window]

        absolute_path = path = options[:path]
        absolute_path = asset_path(absolute_path) unless absolute_path.start_with? "/"

        gosu_song = songs[relative_path]

        unless gosu_song
          gosu_song = create_song(window,absolute_path)
          songs[relative_path] = gosu_song
        end

        Metro::Song.new gosu_song, relative_path
      end

      def self.songs
        @songs ||= {}
      end

      def self.create_song(window,filename)
        Gosu::Song.new(window, filename)
      end

    end
  end
end