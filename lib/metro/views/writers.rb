require_relative 'yaml_view'
require_relative 'json_view'

module Metro
  module Views

    module Writers
      extend self

      #
      # Register a view writer
      #
      # A writer is any class or instance that responds to #write(view_path,content),
      # and #format.
      #
      # @param [Writer] writer the writer to add to the list of available writers..
      #
      def register(writer)
        writers.push writer
      end

      #
      # @return [Array<Writers>] an array of all the registered view writers.
      #
      def writers
        @writers ||= []
      end

      #
      # The default view writer, this is the one that will be used if no view
      # can be found by the writers.
      #
      attr_accessor :default_writer

    end

    Writers.register YAMLView
    Writers.register JSONView
    Writers.default_writer = YAMLView

  end
end

