module Metro
  module UI

    #
    # Generic model is used when no model can be found.
    #
    class Generic < Model

      attr_accessor :warned

      def draw
        log.warn cannot_draw_message unless warned
        self.warned = true
      end

      def cannot_draw_message
        [ "Unable to draw #{name} in #{scene}", "",
          "  The actor named '#{name}' does not specify a suitable model so it could not be drawn in the scene.",
          "", "  " + properties.to_s, "" ].join("\n")
      end

    end
  end
end