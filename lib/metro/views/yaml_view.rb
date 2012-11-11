require 'yaml'

module Metro
  module Views

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
        YAML.load(File.read(yaml_view_path(view_path))) or { }
      end

      #
      # @return the file type format of this view.
      #
      def self.format
        :yaml
      end

      #
      # @param [String] view_path the file path to the view which to save the content
      # @param [Hash] content the content to save within the view
      #
      def self.write(view_path,content)
        filename = write_filepath(view_path)
        yaml_content = content.to_yaml
        File.write(filename,yaml_content)
      end

      #
      # @return the default extension to use when saving yaml files.
      #
      def self.default_extname
        @default_extname || ".yaml"
      end

      #
      # Set the default extname
      #
      # @example
      #
      #     Metro::Views::YAMLView.default_extname = ".yml"
      #
      def self.default_extname=(value)
        @default_extname = value
      end

      private

      #
      # If a file already exists with .yaml or .yml use that extension. Otherwise, we
      # will fall back to the default extension name.
      #
      def self.write_filepath(view_path)
        if existing_file = exists?(view_path)
          existing_file
        else
          "#{view_path}#{default_extname}"
        end
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