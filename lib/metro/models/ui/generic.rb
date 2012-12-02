module Metro
  module UI

    #
    # Generic model is used when no model can be found.
    #
    # @example Defining an actor in a scene without the model
    #
    #     class IntroScene < GameScene
    #
    #       draw :game_title, text: "Super Game Title", position: Game.center
    #         color: "rgba(255,255,255,1.0)"
    #
    #     end
    #
    # The above `game_title` actor was likely suppose to be a `metro::ui::label`, but
    # the model was not specified. So this warning would be generated.
    #
    class Generic < Model

      # @attribute
      # Sets whether the generic model has warned the user in the logs about it
      # being a generic model.
      property :warned, type: :boolean, default: false

      def show
        self.saveable_to_view = false
      end

      def draw
        log.warn cannot_draw_message unless warned
        self.warned = true
      end

      private

      def cannot_draw_message
        %{Unable to draw #{name} in #{scene}

  The actor named '#{name}' does not specify a suitable model so it could not be drawn in the scene.

  #{properties}

  Did you mean to use one of the following models:

  Models defined in #{Game.name}:

  #{user_defined_models.join(', ')}

  Models defined in Metro:

  #{metro_models.join(', ')}
}
      end

      def metro_models
        Models.list.find_all {|m| m =~ /metro(::|\/).+(::|\/).+/i }
      end

      def user_defined_models
        Models.list - metro_models
      end

    end
  end
end