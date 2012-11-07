require 'metro/game/dsl'

module Metro
  module Game
    extend self

    def setup(game_configuration)
      @config = game_configuration
    end

    attr_reader :config

    def first_scene
      fetch(:first_scene)
    end

    def width
      fetch(:width,640)
    end

    def height
      fetch(:height,480)
    end

    def dimensions
      [ width, height ]
    end

    def center
      Units::Point.at width / 2 , height / 2
    end

    def fullscreen?
      !!fetch(:fullscreen)
    end

    def debug?
      !!fetch(:debug)
    end

    def name
      fetch(:name)
    end

    def authors
      fetch(:authors)
    end

    def website
      fetch(:website,Metro::WEBSITE)
    end

    def contact
      fetch(:contact)
    end

    def controls
      config.controls.defined_controls
    end

    def fetch(name,fallback = nil)
      config.send(name) rescue fallback
    end


  end
end