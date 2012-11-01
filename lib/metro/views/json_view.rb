require 'json'

module Metro
  module Views

    #
    # Provides support for a JSON Representation of a view.
    #
    class JSONView

      #
      # Determine if a view exists for this specified format
      #
      # @param [String] view_path the name of the view to find
      # @return a true if the json view exists and false if it does not exist.
      #
      def self.exists?(view_path)
        File.exists? json_view_path(view_path)
      end

      #
      # Parse the contents of the view given the name.
      #
      # @param [String] view_path the name of the view to read
      # @return a Hash that contains the contents of the view.
      #
      def self.parse(view_path)
        JSON.parse File.read json_view_path(view_path)
      end

      #
      # @return the file type format of this view.
      # 
      def self.format
        :json
      end

      #
      # Writes the content out to the spcified view path
      #
      def self.write(view_path,content)
        filename = json_view_path(view_path)
        json_content = JSON.pretty_generate(content)
        File.write(filename,json_content)
      end

      private

      #
      # A helper method to generate the name of the json view file. In this case
      # it is the view name with the suffix .json.
      #
      def self.json_view_path(view_path)
        File.extname(view_path) == "" ? "#{view_path}.json" : view_path
      end

    end

  end
end