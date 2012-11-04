module Metro

  class GenerateScene < Generator

    no_tasks do

      def scene_filename
        scene_name = name.gsub(/_?Scene$/i,'')
        "#{scene_name.underscore}_scene"
      end

      def scene_class_name
        scene_name = name.gsub(/_?Scene$/i,'')
        "#{scene_name.camelize}Scene"
      end

      def view_filename
        view_name = name.to_s.gsub(/_?Scene$/i,'')
        view_name.underscore
      end

    end

    argument :name

    def create_scene_file
      template "scene.rb.tt", "scenes/#{scene_filename}.rb"
    end

    def create_view_file
      template "view.yaml.tt", "views/#{view_filename}.yaml"
    end

  end

end