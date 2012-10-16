require 'gosu'
require "misfits/version"

def asset_path(name)
  File.join Dir.pwd, "assets", name
end

module Misfits

  def self.run(filename="game")

    $LOAD_PATH.unshift(Dir.pwd) unless $LOAD_PATH.include?(Dir.pwd)

    require_relative 'misfits/model'
    Dir['models/*.rb'].each {|model| require model }

    require_relative 'misfits/scene'
    Dir['scenes/*.rb'].each {|scene| require scene }

    game_contents = File.read(filename)

    game_block = lambda {|instance| eval(game_contents) }

    window = Window.new Game::Width, Game::Height, false
    window.instance_eval(&game_block)
    window.show

  end

  module Game
    extend self
    Background, Stars, Players, UI = *0..3
    Width, Height = 640, 480

    def center
      [ Width / 2 , Height / 2 ]
    end
  end

  class Window < Gosu::Window

    attr_reader :scene

    def initialize(width,height,something)
      super width, height, something
    end

    def starting_at(scene)
      @scene = scene.new(self)
    end

    alias_method :gosu_show, :show

    def show
      scene.show
      gosu_show
    end

    def update
      scene.update
    end

    def draw
      scene.draw
    end

  end

end
