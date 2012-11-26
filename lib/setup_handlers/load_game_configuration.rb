module Metro
  module SetupHandlers

    #
    # LoadGameConfiguration is a meta pregame setup handler as it defines multiple
    # setup handlers to be executed related to game configuration.
    #
    class GameConfiguration
      #
      # @param [Metro::Parameters::Options] options the options that the game
      #   was provided when it was launched.
      #
      def setup(options)
        ParseAndLoadGameConfiguration.new.setup(options)
        ConfigureControls.new.setup(options)
      end
    end

    #
    # Loads the game configuration information and sets up a Game object with the
    # content loaded from the game configuration.
    #
    class ParseAndLoadGameConfiguration

      #
      # @param [Metro::Parameters::Options] options the options that the game
      #   was provided when it was launched.
      #
      def setup(options)
        filename = options.filename

        Game.execution_parameters = options.execution_parameters

        gamefile = File.basename(filename)
        game_files_exist!(gamefile)
        game_contents = File.read(gamefile)
        game_block = lambda {|instance| eval(game_contents) }
        game = Game::DSL.parse(&game_block)
        Game.setup game
      end

      def game_files_exist!(*files)
        files.compact.flatten.each { |file| game_file_exists?(file) }
      end

      def game_file_exists?(file)
        error!("error.missing_metro_file",file: file) unless File.exists?(file)
        error!("error.specified_directory",directory: file) if File.directory?(file)
      end
    end

    #
    # After the game has been configured it is time to configure the controls for
    # the game.
    #
    class ConfigureControls
      def setup(options)
        EventRelay.define_controls Game.controls
      end
    end
  end

  register_setup_handler SetupHandlers::GameConfiguration.new

end