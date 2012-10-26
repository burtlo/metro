module Metro

  class GenerateView < ::Thor::Group
    include Thor::Actions

    no_tasks do
      
      def view_filename
        view_name = name.to_s.gsub(/Scene$/i,'')
        view_name.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
        view_name.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
        "#{view_name.downcase}_scene"
      end
      
    end

    argument :name

    def self.source_root
      File.join File.dirname(__FILE__), "..", "..", "templates"
    end

    def create_view_file
      template "view.yml.erb", "views/#{view_filename}.yml"
    end
  end

end