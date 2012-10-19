require 'metro/game/dsl'

module Metro
  module Game
    extend self

    def setup(game_configuration)
      @config = game_configuration
    end

    attr_reader :config

    def first_scene
      config.first_scene
    end

    def width
      config.width || 640
    end

    def height
      config.height || 480
    end

    def dimensions
      [ width, height ]
    end

    def center
      [ width / 2 , height / 2 ]
    end

    def fullscreen?
      !!config.fullscreen
    end
    
    def debug?
      !!config.debug
    end

    # TODO: ZOrder related constants that belong to Starry Knight
    Background, Stars, Players, UI = *0..3

  end
end