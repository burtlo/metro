require_relative 'yaml_view'
require_relative 'json_view'
require_relative 'no_view'

module Metro
  module Views

    module Parsers
      extend self

      def register(parser)
        parsers.push parser
      end

      def parsers
        @parsers ||= []
      end
    end

    Parsers.register YAMLView
    Parsers.register JSONView
    Parsers.register NoView

  end
end

