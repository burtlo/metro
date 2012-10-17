require 'gosu'
require 'logger'

require 'metro/version'
require 'metro/window'
require 'metro/game'

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

  def run(filename="game")

    $LOAD_PATH.unshift(Dir.pwd) unless $LOAD_PATH.include?(Dir.pwd)

    require_relative 'metro/model'
    Dir['models/*.rb'].each {|model| require model }

    require_relative 'metro/scene'
    Dir['scenes/*.rb'].each {|scene| require scene }

    game_contents = File.read(filename)

    game_block = lambda {|instance| eval(game_contents) }

    window = Window.new Game::Width, Game::Height, false
    window.instance_eval(&game_block)
    window.show

  end

end
