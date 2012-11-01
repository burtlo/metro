require_relative 'view'

module Metro

  #
  # SceneView provides support for a Scene to have a view as well as giving
  # additional tools to also help draw that view.
  #
  module SceneView

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
    # @return the view for this scene.
    #
    def view
      self.class.view
    end

    #
    # Loads and caches the view content based on the avilable view parsers and
    # the view files defined.
    #
    # @return the content contained within the view
    #
    def view_content
      view.content
    end

    #
    # Saves the current content of the view back through the view's writer
    #
    def save_view
      view.content = self.to_hash
      view.save
    end

    #
    # When the module is included insure that all the class helper methods are added
    # at the same time.
    #
    def self.included(base)
      base.extend ClassMethods
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
      def view_name(name = nil)
        name ? view.name = name : view.name
        view.name
      end

      #
      # Loads and caches the view content based on the avilable view parsers and
      # the view files defined.
      #
      # @return a view object
      #
      def view
        @view ||=begin
          view = View.new
          view.name = scene_name
          view
        end
      end

    end

  end
end