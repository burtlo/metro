require 'gosu'
require 'gosu_ext/color'
require 'gosu_ext/gosu_constants'
require 'sender'
require 'i18n'


require 'core_ext/string'
require 'core_ext/numeric'
require 'logger'
require 'erb'

require 'locale/locale'
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

def error(messages, details = {})
  details = { show: true }.merge details

  message = TemplateMessage.new messages: messages, details: details,
    website: Game.website, contact: Game.contact

  warn message if details[:show]
  exit 1
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
    configure_controls!
    start_game
  end

  private

  def load_game_files
    $LOAD_PATH.unshift(Dir.pwd) unless $LOAD_PATH.include?(Dir.pwd)
    Dir['models/*.rb'].each {|model| require model }
    Dir['scenes/*.rb'].each {|scene| require scene }
  end

  def load_game_configuration(filename)
    game_files_exist!(filename)
    game_contents = File.read(filename)
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
      error "error.missing_metro_file", file: file
    end
  end

end
