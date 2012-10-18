module Metro
  module SceneView
    class UnsupportedComponent < Drawer
      draws '*'
      
      def self.draw(view)
        #log.warn "The component #{view['type']} does not have a supported drawer."
      end
    end
  end
end