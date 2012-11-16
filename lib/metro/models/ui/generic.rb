module Metro
  module UI

    #
    # Generic model is used when no model is cannot not be found
    # when mapping the view content
    #
    class Generic < Model

      def draw
        raise cannot_draw_message
      end

      def cannot_draw_message
        [ "Unable to draw #{name} in #{scene}",
          "The actor named '#{name}' could not find a suitable model so it could not be drawn in the scene #{scene}" ].join("\n")
      end

    end
  end
end