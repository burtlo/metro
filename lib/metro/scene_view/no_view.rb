module Metro
  module SceneView

    class NoView
      def self.find(view_name)
        true
      end

      def self.parse(view_name)
        {}
      end
    end

  end
end