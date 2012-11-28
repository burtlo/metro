module Metro
  module UI

    #
    # The model labeler will draw a bounding box and label around all the
    # scene's drawers.
    #
    # The model labeler is used in the edit transition scene to generate
    # the bounding boxes and labeles around all the actors within the scene
    # being edited.
    #
    class ModelLabeler < Metro::Model

      # @attribute
      # The color use for the border surrounding each actor and the background
      # behind the model's name.
      property :color, default: "rgba(255,0,0,0.5)"

      # @attribute
      # Sets whether to draw the bounding boxes around the actors.
      property :draw_bounding_boxes, type: :boolean, default: true

      # @attribute
      # The color of the model name text.
      property :label_color, default: "rgba(255,255,255,1.0)"

      # @attribute
      # The font of the model name label.
      property :font, default: { name: 'Arial', size: 16 }

      # @attribute
      # Sets whether to draw the model name labels
      property :draw_labels, type: :boolean, default: true

      # @attribute
      # For actors that have no bounds, like sound or custom models without
      # a position, they are normally hidden but can be shown. Currently they
      # appear all overlapped in the upper-left corner of the screen.
      #
      # @todo when enabled the boundless actors should be presented in a cleaner
      #   way to allow for easier viewing of them.
      property :hide_boundless_actors, type: :boolean, default: true

      def show
        self.saveable_to_view = false
      end

      def draw
        scene.drawers.each do |drawer|
          next if (drawer.bounds == Bounds.none and hide_boundless_actors)
          draw_label(drawer) if draw_labels
          draw_bounding_box(drawer.bounds) if draw_bounding_boxes
        end
      end

      def draw_label(drawer)
        bounds = drawer.bounds
        z_order = drawer.respond_to?(:z_order) ? drawer.z_order + 2 : 0

        label = create "metro::ui::label", font: font, text: drawer.name,
          position: bounds.top_left + Point.at(4,2,z_order)

        label.draw
        draw_quad_behind(label)
      end

      def draw_quad_behind(drawer)
        quad = create "metro::ui::rectangle",
          position: drawer.position - Point.at(2,0,1),
          color: color, dimensions: drawer.dimensions + Dimensions.of(6,4)

        quad.draw
      end

      def draw_bounding_box(bounds)
        box = create "metro::ui::border", position: bounds.top_left,
          dimensions: bounds.dimensions, color: color

        box.draw
      end
    end

  end
end