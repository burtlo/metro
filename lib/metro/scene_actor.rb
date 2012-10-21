module Metro
  class SceneActor

    attr_reader :name, :options

    def initialize(name,options)
      @name = name.to_s.downcase
      @options = options
    end

    def create(contents = {})
      contents = {} unless contents
      actor_instance = class_for_actor(contents['model']).new
      actor_instance._load(contents)
      actor_instance
    end

    def load_from_previous_scene?
      options[:from] == :previous_scene
    end

    def class_for_actor(model_name)
      Model.model(model_name || name)
    end
  end
end