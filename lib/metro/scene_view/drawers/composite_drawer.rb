require_relative 'artists_block'
require_relative 'label'
require_relative 'select'

module Metro
  module SceneView

    #
    # The CompositeDrawer is a special drawer that looks at all the created drawers
    # that have been defined and then determines which one should be used when drawing
    # for a particular view type.
    #
    # This Drawer is used in the SceneView to handle the multitude of view objects
    # that are thrown at it.
    #
    # @see SceneView
    #
    class CompositeDrawer < Drawer

      #
      # @return a Hash which maps the types of things that can be drawn to
      #   the specific drawer.
      #
      def drawers
        @drawers ||= begin

          # By default fall back to having artist's block when you do not know
          # how to draw a particular view component.

          hash = Hash.new(ArtistsBlock)

          Drawer.drawers.each do |drawer|
            drawer.draws_types.each do |type|
              #TODO: Deal with the situation where one drawer overrides an existing drawer
              hash[type] = drawer.new(scene)
            end
          end

          hash
        end
      end

      #
      # Render all the view elements defined that are supported by this drawer.
      #
      def draw(view)
        view.each do |name,content|
          drawer = content['type']
          drawers[drawer].draw(content)
        end
      end

    end
  end
end