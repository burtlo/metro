require 'delegate'
require 'logger'
require 'erb'

require 'gosu'
require 'i18n'
require 'active_support'
require 'active_support/dependencies'
require 'active_support/inflector'
require 'active_support/core_ext/hash'
require 'active_support/hash_with_indifferent_access'

require 'gosu_ext/color'
require 'gosu_ext/gosu_constants'
require 'core_ext/numeric'

require 'locale/locale'

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

  def asset_dir
    File.join File.dirname(__FILE__), "assets"
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
    move_to_game_directory!(filename)
    load_game_files!
    load_game_configuration(filename)
    configure_controls!
    start_game
  end

  def load_game_files!
    EventDictionary.reset!
    prepare_watcher!
    load_game_files
    execute_watcher!
  end

  alias_method :reload!, :load_game_files!

  private

  def move_to_game_directory!(filename)
    game_directory = File.dirname(filename)
    Dir.chdir game_directory
  end

  #
  # The watcher will keep track of all the constants that were added to the Object
  # Namespace after the start of the execution of the game. This will allow for only
  # those objects to be reloaded.
  #
  def watcher
    @watcher ||= ActiveSupport::Dependencies::WatchStack.new
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
    error!("error.missing_metro_file",file: file) unless File.exists?(file)
    error!("error.specified_directory",directory: file) if File.directory?(file)
  end

end
