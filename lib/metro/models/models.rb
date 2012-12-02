module Metro


  module Models
    extend self

    #
    # Add a model, and all it's subclasses, to the list of available models.
    #
    # A model has several names added so that it accessible in many ways:
    #
    # * Model Class Name
    # * Model Name
    # * Model Name with slashes replaced with `::` separator
    #
    def add(model)
      all_models_for(model).each do |model|
        models_hash[model.to_s] = model.to_s
        name_with_slashes = model.model_name
        models_hash[name_with_slashes] = model.to_s
        name_with_colons  = name_with_slashes.gsub('/','::')
        models_hash[name_with_colons] = model.to_s
      end
    end

    #
    # @param [String] name the name of the model that you want to return.
    #
    # @return [String] the name of the model class
    #
    def find(name)
      models_hash[name].constantize
    end

    #
    # @return [Array<String>] all the names supported by the models hash.
    #
    def list
      models_hash.keys
    end

    #
    # @return [Hash] a hash of the available models. The keys are the various
    #   supported names, with the values being the names of the model classes.
    def models_hash
      @models_hash ||= HashWithIndifferentAccess.new("Metro::UI::Generic")
    end

    #
    # @param [Class,Array<Class>] models a model or array of models.
    # @return [Array] an array that contains the model itself and all of the
    #   models that are sub-classes of this model on down.
    #
    def all_models_for(models)
      Array(models).map do |model_class_name|
        model = model_class_name.constantize
        [ model ] + all_models_for(models.models)
      end.flatten.compact
    end

  end
end