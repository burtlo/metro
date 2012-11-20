module Metro
  class ModelFactory

    attr_reader :name

    def initialize(name,options)
      @name = name.to_s.downcase
      @options = options.symbolize_keys
    end

    def create
      actor_class = class_for_actor(model_name)
      actor_class.new options
    end

    def load_from_previous_scene?
      @options[:from] == :previous_scene
    end

    def options
      @options.except(:from)
    end

    def model_name
      options[:model] || name
    end

    def class_for_actor(model_name)
      Model.model(model_name).constantize
    end
  end
end