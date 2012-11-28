require_relative '../events/hit_list'

module Metro

  #
  # The Edit Transition Scene is place where scenes go to be edited. Any scene
  # can transition into edit mode. This scene will copy all the actors and
  # gain access to the view.
  #
  # This scene grants new keyboard commands that will enable, disable, and
  # toggle feature of edit mode:
  #
  # * `e` will end edit mode
  # * `g` will toggle the display of the grid
  # * `l` will toggle the display of the model labels
  # * `b` will toggle the bounding boxes around the models.
  #
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
      self.class.draw :overlay, model: "metro::ui::griddrawer"
      self.class.draw :labeler, model: "metro::ui::modellabeler"
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

    event :on_up, KbG do
      overlay.enabled = !overlay.enabled
    end

    event :on_up, KbL do
      labeler.should_draw_labels = !labeler.should_draw_labels
    end

    event :on_up, KbB do
      labeler.should_draw_bounding_boxes = !labeler.should_draw_bounding_boxes
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
      log.info "Saving changes to Scene #{previous_scene} View - #{view_name}"
      save_view
    end

  end

end