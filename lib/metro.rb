require 'gosu'
require 'gosu_ext/color'
require 'gosu_ext/gosu_constants'
require 'sender'

require 'core_ext/string'
require 'core_ext/numeric'
require 'logger'
require 'erb'

require 'metro/version'
require 'metro/error'
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
    EventRelay.add_controls Game.controls
  end

  def start_game
    window = Window.new Game.width, Game.height, Game.fullscreen?
    window.caption = Game.name
    window.scene = Scenes.generate(Game.first_scene)
    window.show
  end

  def game_files_exist!(*files)
    error_messages = files.compact.flatten.map { |file| game_file_exists?(file) }.reject {|exist| exist == true }
    unless error_messages.empty?
      display_error_message(error_messages)
      exit 1
    end
  end

  def game_file_exists?(file)
    unless File.exists? file
      Error.new title: "Unable to find Metro game file",
        message: "The specified file `#{file}` which is required to run the game could not be found.",
        details: [ "Ensure you have specified the correct file", "Ensure that the file exists at that location" ]
    else
      true
    end
  end

  def display_error_message(messages)
    message = TemplateMessage.new messages: messages, website: WEBSITE, email: CONTACT_EMAILS
    warn message
  end

end
