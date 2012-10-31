require_relative 'yaml_view'
require_relative 'json_view'
require_relative 'no_view'

module Metro

  #
  # SceneView provides support for a Scene to have a view as well as giving
  # additional tools to also help draw that view.
  #
  module SceneView

    #
    # When the module is included insure that all the class helper methods are added
    # at the same time.
    #
    def self.included(base)
      base.extend ClassMethods
    end

    #
    # A Scene by default uses the name of the Scene to find it's associated
    # view.
    #
    # @example Standard View Name
    #
    #     class OpeningScene < Metro::Scene
    #
    #       def show
    #         puts "View Brought To You By: #{view_name} # => View Brought To You By opening
    #       end
    #     end
    #
    # @example Custom View Name
    #
    #     class ClosingScene < Metro::Scene
    #       view_name 'alternative'
    #
    #       def show
    #         puts "View Brought To You By: #{view_name} # => View Brought To You By alternative
    #       end
    #     end
    #
    def view_name
      self.class.view_name
    end

    #
    # Loads and caches the view content based on the avilable view parsers and
    # the view files defined.
    #
    # @return a Hash of view content.
    #
    def view
      self.class.view
    end


    module ClassMethods

      #
      # A Scene by default uses the name of the Scene to find it's associated
      # view.
      #
      # @example Custom View Name
      #
      #     class ClosingScene < Metro::Scene
      #       view_name 'alternative'
      #     end
      #
      #     ClosingScene.view_name # => views/alternative
      #
      def view_name(filename = nil)
        if filename
          @view_name = filename.to_s
        else
          @view_name ||= scene_name
        end
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
        File.join "views", view_name
      end

      #
      # Supported view formats
      #
      def _view_parsers
        [ YAMLView, JSONView, NoView ]
      end

      #
      # Loads and caches the view content based on the avilable view parsers and
      # the view files defined.
      #
      # @return a Hash of view content.
      #
      def view
        @view ||= begin
          parser = _view_parsers.find { |parser| parser.exists? view_path }
          parser.parse view_path
        end
      end

    end

  end
end