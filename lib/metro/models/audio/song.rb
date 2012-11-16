module Metro
  module Audio

    #
    # A song represents an audio representation.
    #
    class Song < Metro::Model

      property :song
      property :volume, default: 1.0
      property :state, type: :text, default: 'play'

      def show
        song.volume = self.volume
        play if state == "play"
      end

      def stop
        song.stop
      end

      def play
        song.play if not song.playing? and not song.paused?
      end

      def pause
        song.playing? ? song.pause : song.play
      end

    end

  end
end