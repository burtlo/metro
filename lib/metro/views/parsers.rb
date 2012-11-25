require_relative 'yaml_view'
require_relative 'json_view'
require_relative 'no_view'

module Metro
  module Views

    module Parsers
      extend self

      #
      # Register a view parser.
      #
      # A parser is any class or instance that responds to #exists?(view_path),
      # #parse(view_path) and #format.
      #
      # @param [Parser] parser the parser to add to the list of available parsers.
      #
      def register(parser)
        parsers.push parser
      end

      #
      # @return [Array<Parsers>] an array of all the registered view parsers. The
      #   last parser is the NoView parser.
      #
      def parsers
        @parsers ||= []
      end

      def parsers_with_no_view_fallback
        parsers + [ NoView ]
      end

    end

    Parsers.register YAMLView
    Parsers.register JSONView

  end
end

