require_relative '../events/hit_list'

module Metro

  class EditTransitionScene < Metro::TransitionScene

    def initialize
      #
      # The EditTransitionScene needs to have all the drawers
      # cleared from the class because it may still have
      # drawers from other things that this was executed.
      #
      # This is a product of using the classes to store the definitions
      # of scene. This means we need to change this so that it is much
      # easier to dup scenes.
      #
      self.class.drawings.clear
      self.class.draw :overlay, model: "Metro::UI::GridDrawer"
      add_actors_to_scene
      after_initialize
    end

    def prepare_transition_from(old_scene)
      next_scene.prepare_transition_from(old_scene)
      @previous_scene = old_scene

      # Set the view name to the previous scene's view name
      self.class.view_name old_scene.view_name
      self.class.view.format = old_scene.class.view.format

      # import all the actors from the previous scene into the current scene.
      old_scene.class.actors.each do |scene_actor|
        self.class.draw scene_actor.name, scene_actor.options
      end

      add_actors_to_scene
    end

    def show
      window.show_cursor
    end

    event :on_up, KbE do
      transition_to next_scene.scene_name
    end

    #
    # Generate a hitlist which manages the click start, hold, and release
    # of the mouse button.
    #
    def hitlist
      @hitlist ||= HitList.new(drawers)
    end

    event :on_down, MsLeft do |event|
      hitlist.hit(event)
    end

    event :on_hold, MsLeft do |event|
      hitlist.update(event)
    end

    event :on_up, MsLeft do |event|
      hitlist.release(event)
    end

    event :on_up, KbS do
      save_view
    end

  end

end