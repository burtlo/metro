module Metro
  class TransitionScene < Scene

    attr_accessor :next_scene, :previous_scene, :options

    def prepare_transition_from(old_scene)
      next_scene.prepare_transition_from(old_scene)
      @previous_scene = old_scene
    end

    def prepare_transition_to(new_scene)
      previous_scene.prepare_transition_to(new_scene)
    end

  end
end

require_relative 'fade_transition_scene'
require_relative 'edit_transition_scene'