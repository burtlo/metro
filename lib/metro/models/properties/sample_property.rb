module Metro
  class Model
    class SampleProperty < Metro::Model::Property

      get do |value|
        default_sample
      end
      
      set do |value|
        default_sample_filename
      end

      get String do |filename|
        self.class.sample_for path: filename, window: model.window
      end

      set String do |filename|
        filename
      end

      set Metro::Sample do |sample|
        sample.path
      end
      
      def default_sample
        self.class.sample_for path: default_sample_filename, window: model.window
      end
      
      def default_sample_filename
        options[:path] || metro_asset_path("unknown_sample.wav")
      end
      

      def self.sample_for(options)
        options.symbolize_keys!
        relative_path = options[:path]
        window = options[:window]

        absolute_path = path = options[:path]
        absolute_path = asset_path(absolute_path) unless absolute_path.start_with? "/"

        gosu_sample = create_sample(window,absolute_path)

        Metro::Sample.new gosu_sample, relative_path
      end

      def self.create_sample(window,filename)
        Gosu::Sample.new(window, filename)
      end

    end
  end
end