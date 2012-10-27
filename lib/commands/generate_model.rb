module Metro

  class GenerateModel < Generator

    no_tasks do

      def model_filename
        name.snake_case
      end

      def model_name
        name.camel_case
      end

    end

    argument :name

    def create_model_file
      template "model.rb.erb", "models/#{model_filename}.rb"
    end

  end

end