require 'gosu'
require "metro/version"

def asset_path(name)
  File.join Dir.pwd, "assets", name
end

module Metro

  def self.run(filename="game")

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
    
    def scene=(new_scene)
      # TODO: transition away from scene
      @scene = new_scene.new(self)
      # TODO: transition to new scene
    end

    alias_method :gosu_show, :show

    def show
      gosu_show
    end

    def update
      scene._events.fire_downer_events
      scene.update
    end

    def draw
      scene.draw
    end
    
    def button_up(id)
      scene._events.button_up(id)
    end
    
    def button_down(id)
      # NOTE: This event does not appear to fire at all.
      scene._events.button_down(id)
    end

  end

end
