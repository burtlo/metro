module Metro
  module SceneView

    class Image < Drawer
      draws 'image'

      attr_reader :images

      def after_initialize
        @images = {}

        content_images = scene.view.find_all { |name,content| self.class.draws_types.include?(content['type']) }

        content_images.each do |name,content|
          @images[name] = create_image(content)
        end
      end

      def create_image(content)
        Gosu::Image.new(window,asset_path(content['path']))
      end

      def draw(view)
        image = images[view['name']]
        image.draw(view['x'] - image.width / 2.0,view['y'] - image.height / 2.0,1)
      end

    end

  end
end