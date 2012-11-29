require 'metro/game/dsl'

module Metro
  module Game
    extend self

    def setup(game_configuration)
      @config = game_configuration
    end

    #
    # Creates a window and starts the game with the game parameters.
    #
    def start!
      @window = Window.new width, height, fullscreen?
      window.caption = name
      window.scene = Scenes.generate(first_scene)
      window.show
    end

    # The original parameters specified during execution. These are the args
    # found on the command-line that are passed in when the game started.
    def execution_parameters
      @execution_parameters ||= []
    end

    attr_writer :execution_parameters

    #
    # @return the current game window.
    #
    attr_reader :window

    #
    # @return [Scene,NilClass] the current scene that is being displayed. If
    #   this is called before the window is being displayed when this will return
    #   a nil value.
    #
    def current_scene
      window ? window.scene : nil
    end

    def first_scene
      fetch(:first_scene)
    end

    def width
      fetch(:width,640)
    end

    def height
      fetch(:height,480)
    end

    def bounds
      Units::RectangleBounds.new left: 0, right: width, top: 0, bottom: height
    end

    def dimensions
      Units::Dimensions.of width, height
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

    attr_reader :config

  end
end