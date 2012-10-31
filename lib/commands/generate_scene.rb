module Metro

  class GenerateScene < Generator

    no_tasks do

      def scene_filename
        scene_name = name.gsub(/_?Scene$/i,'')
        "#{scene_name.underscore}_scene"
      end

      def scene_class_name
        scene_name = name.gsub(/_?Scene$/i,'')
        "#{scene_name.classify}Scene"
      end

    end

    argument :name

    def create_scene_file
      template "scene.rb.erb", "scenes/#{scene_filename}.rb"
    end
  end

end