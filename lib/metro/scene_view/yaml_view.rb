require 'yaml'

module Metro
  module SceneView

    class YAMLView

      #
      # Determine if a view exists for this specified format
      #
      # @param [String] view_name the name of the view to find
      # @return a true if the yaml view exists and false if it does not exist.
      #
      def self.exists?(view_name)
        yaml_view_names(view_name).find { |view_name| File.exists? view_name }
      end

      #
      # Parse the contents of the view given the name.
      #
      # @param [String] view_name the name of the view to read
      # @return a Hash that contains the contents of the view.
      #
      def self.parse(view_name)
        YAML.load File.read yaml_view_name(view_name)
      end

      #
      # A helper method to generate the name of the yaml view file. In this case
      # it is the view name with the suffix .yaml.
      #
      def self.yaml_view_names(view_name)
        File.extname(view_name) == "" ? [ "#{view_name}.yaml", "#{view_name}.yml" ] : [ view_name ]
      end
    end

  end
end