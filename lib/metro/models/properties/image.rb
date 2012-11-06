module Metro
  class Model

    class ImageProperty < Property

      define_property :alpha, prefix: true
      
      get String do |path|
        self.class.image_for_path path: path, window: model.window
      end

      set String do |path|
        path
      end
      
      set Gosu::Image do |image|
        image.path
      end

      def self.image_for_path(options)
        options.symbolize_keys!
        path = options[:path]
        window = options[:window]

        image = images[path]
        unless image
          image = create_image(window,path,false)
          images[path] = image
        end

        image
      end
      
      def self.create_image(window,path,tileable)
        image = Gosu::Image.new(window,asset_path(path),tileable)
        image.path = path
        image
      end

      def self.images
        @images ||= {}
      end

    end

  end
end