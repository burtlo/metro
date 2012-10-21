module Metro
  class SceneActor

    attr_reader :name, :options

    def initialize(name,options)
      @name = name.to_s.downcase
      @options = options
    end

    def create(contents = {})
      contents = {} unless contents
      actor_class = class_for_actor(model_name(contents))
      instance = actor_class.new
      instance._load(contents)
      instance
    end

    def load_from_previous_scene?
      options[:from] == :previous_scene
    end

    def model_name(contents = {})
      contents['model'] || contents[:model] || options['model'] || options[:model] || name
    end

    def class_for_actor(model_name)
      Model.model(model_name)
    end
  end
end