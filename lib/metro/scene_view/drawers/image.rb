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
        image.draw_rot(view['x'],view['y'],1,view['angle'].to_f)
      end

    end

  end
end