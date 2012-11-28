module Metro
  module SetupHandlers

    #
    # When the game is launched in **debug** mode the game directories will be
    # monitored for changes. When a change occurs within one of the game source
    # files the game and scene will be reloaded.
    #
    class ReloadGameOnGameFileChanges

      #
      # @NOTE this is duplication of the paths is also defined in LoadGameFiles.
      # @see Metro::SetupHandlers::LoadGameFiles
      #
      def source_filepaths
        [ 'lib', 'scenes', 'models' ]
      end

      def view_filepaths
        [ 'views' ]
      end

      def asset_filepaths
        [ 'assets' ]
      end

      def all_filepaths
        source_filepaths + view_filepaths + asset_filepaths
      end

      #
      # @param [Metro::Parameters::Options] options the options that the game
      #   was provided when it was launched.
      #
      def setup(options)
        start_watcher if Game.debug?
      end

      def start_watcher
        Thread.abort_on_exception = true
        Thread.new { watch_filepaths(all_filepaths) }
      end

      #
      # Defines the listener that will watch the filepaths
      #
      def watch_filepaths(filepaths)
        listener = Listen.to(*filepaths)
        listener.change(&on_change)
        listener.start
      end

      #
      # @return [Proc] the body of code to execute when a file change event has
      #   been received.
      #
      def on_change
        Proc.new { |modified,added,removed| reload_game_because_files_changed(modified + added + removed) }
      end

      #
      # Perform a game reload if the game source is valid.
      #
      def reload_game_because_files_changed(changed)
        log.debug "Metro has detected #{changed.count} game source #{changed.count != 1 ? 'files have' : 'file has'} changed. RELOADING GAME CODE!"
        if Metro.game_has_valid_code?
          Game.current_scene.after(1.tick) do
            Metro.reload!
            scene_is_being_edited = scene_name == "metro/edit_transition"
            transition_to(scene_name) unless scene_is_being_edited
          end
        end
      end

    end
  end

  register_setup_handler SetupHandlers::ReloadGameOnGameFileChanges.new
end