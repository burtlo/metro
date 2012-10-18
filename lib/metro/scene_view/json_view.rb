require 'json'

module Metro
  module SceneView

    #
    # Provides support for a JSON Representation of a view.
    #
    class JSONView

      #
      # Determine if a view exists for this specified format
      #
      # @param [String] view_name the name of the view to find
      # @return a true if the json view exists and false if it does not exist.
      #
      def self.exists?(view_name)
        File.exists? json_view_name(view_name)
      end

      #
      # Parse the contents of the view given the name.
      #
      # @param [String] view_name the name of the view to read
      # @return a Hash that contains the contents of the view.
      #
      def self.parse(view_name)
        JSON.parse File.read json_view_name(view_name)
      end

      #
      # A helper method to generate the name of the json view file. In this case
      # it is the view name with the suffix .json.
      #
      def self.json_view_name(view_name)
        File.extname(view_name) == "" ? "#{view_name}.json" : view_name
      end
    end

  end
end