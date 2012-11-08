require_relative 'transition_scene'

module Metro
  module SceneTransitions
    extend self

    def insert_transition(scene,options)
      return scene unless options.key?(:with)
      name = options[:with]
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
      transition_name = supported_transitions[name]
      transition_name.constantize
    end

    def supported_transitions
      @supported_transitions ||= begin
        hash = HashWithIndifferentAccess.new("Metro::FadeTransitionScene")
        hash[:edit] = "Metro::EditTransitionScene"
        hash
      end
    end

  end

  #
  # The Scene Transition should act as a filter and allow for
  # common or custom scenes to be inserted between the scene
  # that was about to be displayed.
  #
  Scenes.register_post_filter SceneTransitions

end