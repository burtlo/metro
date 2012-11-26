require_relative 'game_execution'

module Metro
  module SetupHandlers

    #
    # LoadGameFiles will load all the game files within the current working
    # directory that are in the pre-defined Metro game folders.
    #
    # LoadGameFiles uses ActiveSupport::Dependencies::WatchStack to spy on all
    # the constants that are added when the game runs. This grants the class
    # the ability to provide dynamic reloading of the classes as they change.
    #
    class LoadGameFiles

      #
      # @param [Metro::Parameters::Options] options the options that the game
      #   was provided when it was launched.
      #
      def setup(options)
        load_game_files!
      end

      #
      # Drop any already defined events. Drop all the existing classes, reload
      # the game files, and prepare the new game files for unloading the next
      # time around that reload has been called.
      #
      def load_game_files!
        EventDictionary.reset!
        Image.images.clear
        Animation.images.clear
        Song.songs.clear
        Font.fonts.clear

        prepare_watcher!
        load_game_files
        execute_watcher!
      end

      #
      # Launch the game in a sub-process in dry-run mode. Starting the
      # game in dry-run mode here makes it so it will not launch a window
      # and simply check to see if the code is valid and working correctly.
      #
      def launch_game_in_dry_run_mode
        GameExecution.execute Game.execution_parameters + [ "--dry-run" ]
      end

      #
      # The watcher should watch the Object Namespace for any changes. Any constants
      # that are added will be tracked from this point forward.
      #
      def prepare_watcher!
        ActiveSupport::Dependencies.clear
        watcher.watch_namespaces([ Object ])
      end

      #
      # The watcher will keep track of all the constants that were added to the Object
      # Namespace after the start of the execution of the game. This will allow for only
      # those objects to be reloaded.
      #
      def watcher
        @watcher ||= ActiveSupport::Dependencies::WatchStack.new
      end

      def load_game_files
        $LOAD_PATH.unshift(Dir.pwd) unless $LOAD_PATH.include?(Dir.pwd)
        load_paths 'lib'
        load_path 'scenes', prioritize: 'game_scene.rb'
        load_path 'models', prioritize: 'game_model.rb'
      end

      def load_paths(*paths)
        paths.flatten.compact.each {|path| load_path path }
      end

      def load_path(path,options = {})
        files = Dir["#{path}/**/*.rb"]
        files.sort! {|file| File.basename(file) == options[:prioritize] ? -1 : 1 }
        files.each {|file| require_or_load file }
      end

      #
      # The watcher will now mark all the constants that it has watched being loaded
      # as unloadable. Doing so exhausts the list of constants found so the watcher
      # will be empty.
      #
      # @note an exception is raised if the watcher is not prepared every time this
      #   is called.
      #
      def execute_watcher!
        watcher.new_constants.each { |constant| unloadable constant }
      end
    end
  end

  register_setup_handler SetupHandlers::LoadGameFiles.new

end
