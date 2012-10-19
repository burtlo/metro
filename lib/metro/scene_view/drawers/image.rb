module Metro
  module SceneView

    class Image < Drawer
      draws 'image'

      attr_reader :images

      def after_initialize
        @images = {}

        content_images = scene.view.find_all { |name,content| self.class.draws_types.include?(content['type']) }

        content_images.each do |name,content|
          # TODO: The name should be used here as the key, however, the name is not passed into
          #   the draw method, so it would not map correctly.
          @images[content["path"]] = create_image(content)
        end
      end

      def create_image(content)
        Gosu::Image.new(window,asset_path(content["path"]))
      end

      def draw(view)
        images[view['path']].draw(view["x"],view["y"],1)
      end

    end

  end
end