require 'thor'
require 'thor/group'

module Metro

  class Generator < ::Thor::Group
    include Thor::Actions

    def self.source_root
      File.join File.dirname(__FILE__), "..", "templates"
    end
  end

  class UnknownGenerator

    def self.start(commands)
      raise "There is no command: [ #{commands.join(', ')} ]"
    end

  end


  class Thor < Thor

    no_tasks do

      def banner
        """
********************************************************************************
  ______  ___      _____
  ___   |/  /_____ __  /_______________
  __  /|_/ / _  _ \\_  __/__  ___/_  __ \\
  _  /  / /  /  __// /_  _  /    / /_/ /
  /_/  /_/   \\___/ \\__/  /_/     \\____/

-------------------------------------------------------------------------------"""
      end

      def generators
        Hash.new(UnknownGenerator).merge model: Metro::GenerateModel,
          scene: Metro::GenerateScene,
          view:  Metro::GenerateView
      end

      def generator(name)
        generators[name.to_sym]
      end

    end

    desc "new GAMENAME",
      "Create a new game within the directory using with the GAMENAME given."
    def new(game_name)
      Metro::GenerateGame.start [ game_name ]
    end

    desc "generate TYPE NAME",
      "Create a new type: model, view, or scene."
    def generate(type,name)
      gen = generator(type)
      gen.start [ name ]
    end
    
    desc "g TYPE NAME",
      "Create a new type: model, view, or scene."
    def g(type,name)
      generate(type,name)
    end
    
    desc "help", "This commoand"
    def help
      say banner
      print_table self.class.printable_tasks, indent: 4
    end

  end
end


require_relative 'generate_game'
require_relative 'generate_model'
require_relative 'generate_scene'
require_relative 'generate_view'
