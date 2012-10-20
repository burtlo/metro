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

        image.draw_rot view['x'], view['y'], view['z-order'],
          view['angle'].to_f,
          view['center-x'] || 0.5, view['center-y'] || 0.5,
          view['factor-x'] || 1, view['factor-y'] || 1,
          view['color'] || 0xffffffff
          
      end

    end

  end
end