module Metro
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