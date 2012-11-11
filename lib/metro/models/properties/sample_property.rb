module Metro
  class Model

    #
    # A sample property maintains a Gosu::Sample.
    #
    # A sample is stored in the properties as the path in the assets folder and is converted into
    # a Gosu::Sample when it is retrieved within the system. When retrieving a sample the Sample
    # Property will attempt to use a sample that already exists that meets that criteria.
    #
    # @example Defining a sample property
    #
    #     class Hero < Metro::Model
    #       property :sample
    #     end
    #
    # @example Defining a sample property providing a default
    #
    #     class Hero < Metro::Model
    #       property :sample, path: 'pickup.wav'
    #     end
    #
    # @example Using a sample property with a different property name
    #
    #     class Hero < Metro::Model
    #       property :pickup_sample, type: :sample, path: 'pickup.wav'
    #     end
    #
    class SampleProperty < Metro::Model::Property

      # By default, getting an unsupported value will return the default sample
      get do |value|
        default_sample
      end

      # Bu default, setting sn unsupported value will save the default sample filename
      set do |value|
        default_sample_filename
      end

      # Generate a sample from the specified string filepath
      get String do |filename|
        self.class.sample_for path: filename, window: model.window
      end

      # The assumption here is that the string is a sample filepath
      set String do |filename|
        filename
      end

      # Setting the song value with a Metro::Sample will save the string filepath
      set Metro::Sample do |sample|
        sample.path
      end

      #
      # @return the default sample for the sample property. This is based on the default
      #   sample name.
      #
      def default_sample
        self.class.sample_for path: default_sample_filename, window: model.window
      end

      #
      # @return a string sample name that is default. If the property was not created with
      #   a default value the the default sample is the missing sample found in Metro.
      #
      def default_sample_filename
        options[:path] or "missing.wav"
      end

      #
      # Returns a Metro::Sample. This is composed of the metadata provided and a Gosu::Sample.
      #
      # @param [Hash] options the path, window, and other parameters necessary to generate
      #   a sample.
      #
      def self.sample_for(options)
        Metro::Sample.create(options)
      end

    end
  end
end