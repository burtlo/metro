module Metro

  class GenerateGame < ::Thor::Group
    include Thor::Actions

    no_tasks do

    end

    argument :name

    def self.source_root
      File.join File.dirname(__FILE__), "..", "..", "templates"
    end

    def create_metro_file
      template "metro.erb", "#{name}/metro"
    end

    def create_readme_file
      template "README.md.erb", "#{name}/README.md"
    end
    
    def create_assets_directory
      run "mkdir -p #{name}/assets"
    end
    
    def create_models_directory
      run "mkdir -p #{name}/models"
    end
    
    def create_views_directory
      run "mkdir -p #{name}/views"
    end
    
  end

end