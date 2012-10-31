module Metro


  class EditTransitionScene < Metro::TransitionScene

    def after_initailize
      # The EditTransitionScene needs to have all the drawers
      # cleared from the class because it may still have 
      # drawers from other things that this was executed.
      self.class.drawings.empty
    end

    def prepare_transition_from(old_scene)
      next_scene.prepare_transition_from(old_scene)
      @previous_scene = old_scene

      # Set the view name to the previous scene's view name
      self.class.view_name old_scene.view_name
      
      # import all the actors from the previous scene into the current scene.
      old_scene.class.actors.each do |scene_actor|
        self.class.draw scene_actor.name, scene_actor.options
      end

      add_actors_to_scene
    end

    def show
      window.cursor = true

      edit_overlay = Metro::Models::GridDrawer.new
      edit_overlay.window = window
      edit_overlay.scene = self

      drawers.push edit_overlay
    end

    event :on_up, KbE do
      log.debug "Closing Edit Mode"
      transition_to next_scene.class.scene_name
    end

    event :on_down, MsLeft do |event|
      # puts "Looking for targets at #{event.mouse_x},#{event.mouse_y}"

      hit_drawers = drawers_at(event.mouse_x,event.mouse_y)

      @selected_drawers = hit_drawers
      @last_event = event
      # if the click is within the bounding box of an on screen item
      # then we want to add that item to the list of items that are going to be dragged
      # We also need to make sure we maintain the offset that we selected them at.
    end

    event :on_hold, MsLeft do |event|
      # puts "Dragging targets to #{event.mouse_x},#{event.mouse_y}"

      offset_x = event.mouse_x - @last_event.mouse_x
      offset_y = event.mouse_y - @last_event.mouse_y

      # puts "Offset: #{offset_x},#{offset_xset_y}"
      @selected_drawers.each do |d|
        d.offset(offset_x,offset_y)
      end

      @last_event = event

    end

    event :on_up, MsLeft do |event|
      puts "Releasing targets at #{event.mouse_x},#{event.mouse_y}"

      # maybe snapping to a grid or rounding their location
      offset_x = event.mouse_x - @last_event.mouse_x
      offset_y = event.mouse_y - @last_event.mouse_y

      @selected_drawers.each do |d|
        d.offset(offset_x,offset_y)
      end

      @selected_drawers = []
      @last_event = event

    end

    def drawers_at(x,y)
      hit_drawers = drawers.find_all do |drawer|
        # where x and y is within the bounds of the drawer
        drawer.contains?(x,y)
      end

      puts "Found: #{hit_drawers}"
      # Filter on z-order
      top_drawer = hit_drawers.inject(hit_drawers.first) {|top,drawer| drawer.z_order > top.z_order ? drawer : top }
      [ top_drawer ].compact
    end

    event :on_up, KbS do
      save
    end

    def save
      puts "Saving"
      save_view
    end

  end

end