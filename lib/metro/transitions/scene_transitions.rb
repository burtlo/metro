require_relative 'fade_transition_scene'

module Metro
  module SceneTransitions
    extend self

    def insert_transition(scene,options)
      return scene unless options.key?(:with)
      generate_transition(name,scene)
    end

    alias_method :filter, :insert_transition

    def generate_transition(name,next_scene)
      transition_scene = find_transition(name).new
      transition_scene.next_scene = next_scene
      transition_scene
    end

    def find_transition(name)
      supported_transitions[name]
    end

    def supported_transitions
      Hash.new(FadeTransitionScene)
    end

  end
end