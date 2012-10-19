require_relative 'artists_block'
require_relative 'label'
require_relative 'select'
require_relative 'image'

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
      # Render all the view elements defined that are supported by this drawer.
      #
      def draw(view)
        view.each do |name,content|
          type = content['type']
          drawers[type].draw(content.merge 'name' => name)
        end
      end

      #
      # Given all the registered drawers map the things that they can draw
      # to the particular drawer.
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

              if not hash.key?(type) or (hash.key?(type) and override_on_conflict?(drawer,type))
                hash[type] = drawer.new(scene)
              end

            end
          end

          hash
        end
      end

      #
      # @return true if the drawer should override the existing drawer, false if the drawer
      #   should leave the existing drawer in it's place.
      #
      def override_on_conflict?(drawer,type)
        if drawer.draw_options[:override]
          true
        else
          log.warn override_warning_message(drawer,type)
          false
        end
      end

      def override_warning_message(drawer,type)
        [ "Drawer Attempting to Override Existing Drawer For '#{type}'",
          "#{drawer} will NOT be drawing '#{type}' as it is being handled by another Drawer.",
          "To override this in the #{drawer.class} class specify the parameter \"draws '#{type}', overrides: true\"" ].join("\n")
      end

    end
  end
end