require 'yaml'

module Metro
  module SceneView

    class YAMLView

      #
      # Determine if a view exists for this specified format
      #
      # @param [String] view_path the name of the view to find
      # @return a true if the yaml view exists and false if it does not exist.
      #
      def self.exists?(view_path)
        yaml_view_paths(view_path).find { |view_path| File.exists? view_path }
      end

      #
      # Parse the contents of the view given the name.
      #
      # @param [String] view_path the name of the view to read
      # @return a Hash that contains the contents of the view.
      #
      def self.parse(view_path)
        YAML.load File.read yaml_view_path(view_path)
      end

      #
      # A helper method to get the view file.
      # 
      def self.yaml_view_path(view_path)
        yaml_view_paths(view_path).find { |view_path| File.exists? view_path }
      end

      #
      # A helper method to generate the name of the yaml view file. In this case
      # it is the view name with the suffix `.yaml` or `.yml`.
      #
      def self.yaml_view_paths(view_path)
        File.extname(view_path) == "" ? [ "#{view_path}.yaml", "#{view_path}.yml" ] : [ view_path ]
      end
    end

  end
end