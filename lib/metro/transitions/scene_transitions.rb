require_relative 'transition_scene'

module Metro
  module SceneTransitions
    extend self

    def insert_transition(scene,options)
      return scene unless options.key?(:with)
      generate_transition(name,scene,options)
    end

    alias_method :filter, :insert_transition

    def generate_transition(name,next_scene,options)
      transition = find_transition(name).new
      transition.next_scene = next_scene
      transition.options = options
      transition
    end

    def find_transition(name)
      supported_transitions[name]
    end

    def supported_transitions
      Hash.new(FadeTransitionScene)
    end

  end
end