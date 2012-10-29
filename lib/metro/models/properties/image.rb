module Metro
  class Model

    class ImageProperty < Property

      def get(value)
        value = value || options[:path]
        self.class.image_for_path path: value, window: model.window
      end

      def set(value)

      end

      def self.image_for_path(options)
        path = options[:path]
        window = options[:window]

        image = images[path]
        unless image
          image = Gosu::Image.new(window,asset_path(path),false)
          images[path] = image
        end

        image
      end

      def self.images
        @images ||= {}
      end

    end

  end
end