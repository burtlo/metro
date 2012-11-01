module Metro
  module Views

    class NoView

      #
      # A NoView is a last resort view which means this is will always will exist.
      #
      # @param [String] view_path the name of the view to find
      # @return a true if the json view exists and false if it does not exist.
      #
      def self.exists?(view_path)
        true
      end

      #
      # A NoView will return an empty Hash to provide compatibility with other view
      # types.
      #
      def self.parse(view_path)
        {}
      end

      #
      # @return the file type format of this view.
      #
      def self.format
        :none
      end

    end

  end
end