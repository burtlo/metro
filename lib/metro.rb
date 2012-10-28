require 'gosu'
require 'gosu_ext/color'
require 'gosu_ext/gosu_constants'
require 'i18n'


require 'core_ext/string'
require 'core_ext/numeric'
require 'logger'
require 'erb'

require 'locale/locale'
require 'metro/asset_path'
require 'metro/logging'
require 'metro/version'
require 'metro/template_message'
require 'metro/window'
require 'metro/game'
require 'metro/scene'
require 'metro/scenes'
require 'metro/models/model'
require 'metro/models/generic'

require_relative 'metro/missing_scene'

#
# To allow an author an easier time accessing the Game object from within their game.
# They do not have to use the `Metro::Game` an instead use the `Game` constant.
#
Game = Metro::Game

module Metro
  extend self
  extend GosuConstants

  #
  # @return [String] the default filename that contains the game contents
  #
  def default_game_filename
    'metro'
  end

  #
  # Run will load the contents of the game contents and game files
  # within the current working directory and start the game. By default
  # calling run with no parameter will look for a game file
  #
  # @param [String] filename the name of the game file to run. When not specified
  #   the value uses the default filename.
  #
  def run(filename=default_game_filename)
    load_game_files
    change_into_game_directory(filename)
    load_game_configuration(filename)
    configure_controls!
    start_game
  end

  private

  def load_game_files
    $LOAD_PATH.unshift(Dir.pwd) unless $LOAD_PATH.include?(Dir.pwd)
    load_paths 'models', 'scenes', 'lib'
  end
  
  def change_into_game_directory(filename)
    game_directory = File.dirname(filename)
    Dir.chdir game_directory
  end

  def load_paths(*paths)
    paths.flatten.compact.each {|path| load_path path }
  end

  def load_path(path)
    Dir["#{path}/**/*.rb"].each {|model| require model }
  end

  def load_game_configuration(filename)
    gamefile = File.basename(filename)
    game_files_exist!(gamefile)
    game_contents = File.read(gamefile)
    game_block = lambda {|instance| eval(game_contents) }
    game = Game::DSL.parse(&game_block)
    Game.setup game
  end

  def configure_controls!
    EventRelay.define_controls Game.controls
  end

  def start_game
    window = Window.new Game.width, Game.height, Game.fullscreen?
    window.caption = Game.name
    window.scene = Scenes.generate(Game.first_scene)
    window.show
  end

  def game_files_exist!(*files)
    files.compact.flatten.each { |file| game_file_exists?(file) }
  end


  def game_file_exists?(file)
    unless File.exists? file
      error! "error.missing_metro_file", file: file
    end
  end

end
