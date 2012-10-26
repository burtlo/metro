module Metro

  class GenerateScene < ::Thor::Group
    include Thor::Actions

    no_tasks do

      def scene_filename
        scene_name = name.to_s.gsub(/Scene$/i,'')
        scene_name.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
        scene_name.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
        "#{scene_name.downcase}_scene"
      end

      def scene_name
        string = name.to_s.to_s.gsub(/Scene$/i,'')
        string = string.sub(/^[a-z\d]*/) { $&.capitalize }
        string = string.gsub(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }.gsub('/', '::')
        "#{string}Scene"
      end

    end

    argument :name

    def self.source_root
      File.join File.dirname(__FILE__), "..", "..", "templates"
    end

    def create_scene_file
      template "scene.rb.erb", "scenes/#{scene_filename}.rb"
    end
  end

end