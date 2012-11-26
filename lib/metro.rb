require 'delegate'
require 'logger'
require 'erb'
require 'open3'

require 'gosu'
require 'i18n'
require 'listen'
require 'active_support'
require 'active_support/dependencies'
require 'active_support/inflector'
require 'active_support/core_ext/hash'
require 'active_support/hash_with_indifferent_access'

require 'gosu_ext/color'
require 'gosu_ext/gosu_constants'
require 'core_ext/numeric'

require 'locale/locale'

require 'metro/parameters/parameters'
require 'metro/asset_path'
require 'metro/units/units'
require 'metro/logging'
require 'metro/version'
require 'metro/animation'
require 'metro/font'
require 'metro/image'
require 'metro/sample'
require 'metro/song'
require 'metro/template_message'
require 'metro/window'
require 'metro/game'
require 'metro/scene'
require 'metro/scenes'
require 'metro/models/model'
require 'metro/missing_scene'

#
# To allow an author an easier time accessing the Game object from within their game.
# They do not have to use the `Metro::Game` an instead use the `Game` constant.
#
Game = Metro::Game

module Metro
  extend self
  extend GosuConstants

  #
  # @return [String] the filepath to the Metro executable
  #
  def executable_path
    File.absolute_path File.join(File.dirname(__FILE__), "..", "bin", "metro")
  end

  #
  # @return [String] the filepath to the Metro assets
  #
  def asset_dir
    File.join File.dirname(__FILE__), "assets"
  end

  #
  # @return [Array] an array of all the handlers that will be executed prior
  #   to the game being launched.
  #
  def setup_handlers
    @setup_handlers ||= []
  end

  #
  # Register a setup handler. While this method is present, it is far
  # too late for game code to be executed as these pregame handlers will already
  # have started executing. This allows for modularity within the Metro library
  # with the possibility that this functionality could become available to
  # individual games if the load process were to be updated.
  #
  def register_setup_handler(handler)
    setup_handlers.push handler
  end

  #
  # Run will load the contents of the game contents and game files
  # within the current working directory and start the game.
  #
  # @param [Array<String>] parameters an array of parameters that contains
  #   the commands in the format that would normally be parsed into the
  #   ARGV array.
  #
  def run(*parameters)
    options = Parameters::CommandLineArgsParser.parse(parameters)
    setup_handlers.each { |handler| handler.setup(options) }
    start_game
  end

  #
  # Start the game by lanunching a window with the game configuration and data
  # that has been loaded.
  #
  def start_game
    Game.start!
  end

  #
  # When called all the game-related code will be unloaded and reloaded.
  # Providding an opportunity for a game author to tweak the code without having
  # to restart the game.
  #
  def reload!
    SetupHandlers::LoadGameFiles.new.load_game_files!
  end

  #
  # When called the game-related code will be loaded in a sub-process to see
  # if the code is valid. This is used in tandem with {#reload} and should be
  # called prior to ensure that the code that is replacing the current code
  # is valid.
  #
  # @return [TrueClass,FalseClass] true if the game code that was loaded was
  #   loaded successfully. false if the game code was not able to be loaded.
  #
  def game_has_valid_code?
    execution = SetupHandlers::LoadGameFiles.new.launch_game_in_dry_run_mode

    if execution.invalid?
      error! 'error.unloadable_source', output: execution.output, exit: false
    end

    execution.valid?
  end
end

require 'setup_handlers/move_to_game_directory'
require 'setup_handlers/load_game_files'
require 'setup_handlers/load_game_configuration'
require 'setup_handlers/exit_if_dry_run'
require 'setup_handlers/reload_game_on_game_file_changes'
