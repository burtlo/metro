require_relative 'view_parsers'

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
      @content ||= parse
    end

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
      @parser ||= supported_view_parsers.find { |parser| parser.exists? view_path }
    end

    #
    # Ask the parser to write the view content back.
    #
    def save
      parser.write(self)
    end


    #
    # Supported view formats
    #
    def supported_view_parsers
      Views::Parsers.parsers
    end

  end

end