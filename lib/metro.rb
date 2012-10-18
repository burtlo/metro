require 'gosu'
require 'logger'

require 'metro/version'
require 'metro/window'
require 'metro/game'
require 'metro/model'
require 'metro/scene'

def asset_path(name)
  File.join Dir.pwd, "assets", name
end


def log
  @log ||= begin
    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG
    logger
  end
end

module Metro
  extend self

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
    load_game_configuration(filename)
    start_game
  end

  private

  def load_game_files
    $LOAD_PATH.unshift(Dir.pwd) unless $LOAD_PATH.include?(Dir.pwd)
    Dir['models/*.rb'].each {|model| require model }
    Dir['scenes/*.rb'].each {|scene| require scene }
  end

  def load_game_configuration(filename)
    game_contents = File.read(filename)
    game_block = lambda {|instance| eval(game_contents) }
    game = Game::DSL.parse(&game_block)
    Game.setup game
  end

  def start_game
    window = Window.new Game.width, Game.height, Game.fullscreen?
    window.scene = Game.first_scene.new(window)
    window.show
  end

end
