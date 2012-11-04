module Metro

  class GenerateModel < Generator

    no_tasks do

      def model_filename
        name.underscore
      end

      def model_name
        name.camelize
      end

    end

    argument :name

    def create_model_file
      template "model.rb.tt", "models/#{model_filename}.rb"
    end

  end

end