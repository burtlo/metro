module Metro

  class GenerateView < Generator

    no_tasks do

      def view_filename
        view_name = name.to_s.gsub(/_?Scene$/i,'')
        view_name.underscore
      end

    end

    argument :name

    def create_view_file
      template "view.yaml.tt", "views/#{view_filename}.yaml"
    end
  end

end