module Metro

  #
  # A subclass of the Gosu::Window which simply acts as system
  # to shuffle in and out scenes and relay event information.
  #
  class Window < Gosu::Window

    #
    # The scene of the window.
    #
    # @see Scene
    #
    attr_accessor :scene

    #
    # @param [Fixnum] width the width of the game window
    # @param [Fixnum] height the height of the game window
    # @param [TrueClass,FalseClass] fullscreen the boolean flag to enable or
    #   disable fullscreen
    #
    def initialize(width,height,fullscreen)
      super width, height, fullscreen
    end

    def scene=(scene)
      scene.window = self
      @scene = scene
    end

    #
    # This is called every update interval while the window is being shown.
    #
    def update
      scene.fire_events_for_held_buttons
      scene.base_update
    end

    #
    # This is called after every {#update} and when the OS wants the window to
    # repaint itself.
    #
    def draw
      scene.base_draw
    end

    #
    # Called before {#update} when the user releases a button while the window
    # has focus.
    #
    def button_up(id)
      scene.button_up(id)
    end

    #
    # Called before {#update} when the user presses a button while the window
    # has focus.
    #
    def button_down(id)
      scene.button_down(id)
    end

    #
    # @return the dimensions of the current window.
    #
    def dimensions
      Metro::Units::Dimensions.of width, height
    end

    #
    # Define an acessor that enables/disables the use of a cursor
    # within the window. The value should be truthy/falsy.
    #
    attr_accessor :cursor

    #
    # Gosu uses this method to determine if the cursor should be shown.
    #
    alias_method :needs_cursor?, :cursor

    def show_cursor
      self.cursor = true
    end

    def hide_cursor
      self.cursor = false
    end

  end
end