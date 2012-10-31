require_relative 'yaml_view'
require_relative 'json_view'

module Metro
  module Views

    module Writers
      extend self

      def register(writer)
        writers.push writer
      end

      def writers
        @writers ||= []
      end

      attr_accessor :default_writer

    end

    Writers.register YAMLView
    Writers.register JSONView
    Writers.default_writer = YAMLView

  end
end

