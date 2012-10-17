require 'yaml'

module Metro
  module SceneView

    class YAMLView
      def self.find(view_name)
        File.exists? yaml_view_name(view_name)
      end

      def self.parse(view_name)
        YAML.load File.read yaml_view_name(view_name)
      end

      def self.yaml_view_name(view_name)
        File.extname(view_name) == "" ? "#{view_name}.yaml" : view_name
      end
    end

  end
end