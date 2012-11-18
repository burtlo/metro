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

      attr_accessor :warned

      def draw
        log.warn cannot_draw_message unless warned
        self.warned = true
      end

      private

      def cannot_draw_message
        [ "Unable to draw #{name} in #{scene}", "",
          "  The actor named '#{name}' does not specify a suitable model so it could not be drawn in the scene.",
          "", "  " + properties.to_s, "" ].join("\n")
      end

    end
  end
end