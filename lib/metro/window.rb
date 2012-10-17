require_relative 'scenes'

module Metro
  class Window < Gosu::Window

    attr_reader :scene

    def initialize(width,height,something)
      super width, height, something
    end

    def scene=(new_scene)
      @scene = new_scene
    end

    def update
      scene._events.trigger_held_buttons
      scene.update
    end

    def draw
      scene.draw
    end

    def button_up(id)
      scene._events.button_up(id)
    end

    def button_down(id)
      scene._events.button_down(id)
    end

  end
end