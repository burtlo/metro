require_relative 'parsers'
require_relative 'writers'

module Metro

  #
  # A view represents the representation of the content found within
  # the view file. A view has the ability to save/load the content
  # as well.
  #
  class View

    #
    # The name of the view, which is used to influence the file path.
    #
    attr_accessor :name

    #
    # The content contained within the view.
    #
    def content
      @content ||= begin
        parsed_content = parse
        parsed_content.default = {}
        parsed_content
      end
    end

    attr_writer :content

    #
    # A Scene view path is based on the view name.
    #
    # @example Standard View Path
    #
    #     class OpeningScene < Metro::Scene
    #     end
    #
    #     OpeniningScene.view_path # => views/opening
    #
    # @example Custom View Path
    #
    #     class ClosingScene < Metro::Scene
    #       view_name 'alternative'
    #     end
    #
    #     ClosingScene.view_path # => views/alternative
    #
    def view_path
      File.join "views", name
    end

    #
    # Parse the content found at the view path for the view.
    #
    # @return the hash of content stored within the view file.
    #
    def parse
      parser.parse(view_path)
    end

    #
    # The parser for this view is one of the supported parsers. A parser
    # is selected if the parser is capable of finding the content to
    # load.
    #
    def parser
      @parser ||= supported_parsers.find { |parser| parser.exists? view_path }
    end

    #
    # Supported view formats
    #
    def supported_parsers
      Views::Parsers.parsers
    end

    #
    # Ask the parser to save the current content of the view at the view path
    #
    def save
      writer.write(view_path,content)
    end

    #
    # The writer for this view. If the view has already been parsed then use
    #
    def writer
      @writer ||= begin
        writer_matching_existing_parser = supported_writers.find { |writer| parser.format == writer.format }
        writer_matching_existing_parser || default_writer
      end
    end

    def supported_writers
      Views::Writers.writers
    end
    
    def default_writer
      Views::Writers.default_writer
    end

  end

end