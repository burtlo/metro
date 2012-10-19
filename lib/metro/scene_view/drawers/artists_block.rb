module Metro
  module SceneView

    #
    # This Drawer draws nothing. This is a nod to the age old struggle that
    # as artists we struggle with the impetus and ability to convey a message
    # but simply lack the message.
    #
    # It is the fallback drawer when no suitable drawer can be found.
    #
    class ArtistsBlock < Drawer
      def self.draw(view)
        # log.warn "The component #{view['type']} does not have a supported drawer."
      end
    end
  end
end