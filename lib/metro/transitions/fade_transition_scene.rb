module Metro
  class FadeTransitionScene < Metro::Scene

    attr_accessor :next_scene, :previous_scene

    draw :rectangle, model: "metro::models::rectangle",
      color: "rgb(255,255,255)"

    animate actor: :rectangle, to: { color: "rgb(0,0,0)" }, interval: 60 do
      transition_to next_scene
    end
      
    def prepare_transition_from(old_scene)
      next_scene.prepare_transition_from(old_scene)
      @previous_scene = old_scene
    end

    def prepare_transition_to(new_scene)
      previous_scene.prepare_transition_to(new_scene)
    end

  end
end