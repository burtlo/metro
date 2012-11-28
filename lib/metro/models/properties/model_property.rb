module Metro
  class Model

    #
    # A model property maintains a reference to another model. This property
    # allows for an existing model to be more easily composed with other models.
    #
    # The model is stored as a hash which describes the model.
    #
    # @example Defining a model property with a block
    #
    #     class ScoreBoard < Metro::Model
    #       property :position
    #       property :score
    #       property :label, type: :model do
    #         create "metro::ui::label", text: "", position: position
    #       end
    #     end
    #
    # @example Defining a model property with a hash
    #
    #     class ScoreBoard < Metro::Model
    #       property :position
    #       property :score
    #       property :label, type: :model, default: { model: "metro::ui::label",
    #         text: "", position: position }
    #       end
    #     end
    #
    class ModelProperty < Property

      # When retrieving a model and the type is unsupported generate the
      # model instance from the default.
      get do
        default_model
      end

      # When retrieving a hash representation of the model, convert it into
      # a Metro::Model instance.
      get Hash do |params|
        create_model params
      end

      # When setting the property with an unsupported type, simply save an
      # empty hash. Which later, if retrieved, it will generate a generic
      # model.
      set do
        {}
      end

      # When setting the property with a hash, assume that the hash is a
      # valid description of a Metro::Model.
      set Hash, HashWithIndifferentAccess do |hash|
        hash
      end

      # When setting the property with a Metro::Model, convert the model into
      # a hash.
      set Metro::Model do |model|
        model.to_hash
      end

      #
      # Allow for a model property to be defined with a block initialization or
      # a default hash.
      #
      def default_model
        if block
          model.instance_eval(&block)
        else
          create_model options[:default]
        end
      end

      # @return [Metro::Model] return a model created by the current model that
      #   owns the property.
      def create_model
        model.create params[:model], params.except(:model)
      end

    end

  end
end