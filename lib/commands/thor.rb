require 'thor'
require 'thor/group'

require_relative 'generate/game'
require_relative 'generate/model'
require_relative 'generate/scene'
require_relative 'generate/view'

module Metro
  class Thor < Thor

    desc "new", "Generate a new game at the specified file path"
    def new(game_name)
      Metro::GeneratGame.start [ game_name ]
    end

    desc "generate", "Generate new game models, views, or scenes"
    def generate(type,name)

      generator = Metro.const_get "Generate#{type.capitalize}"
      generator.start [ name ]

    end

  end
end