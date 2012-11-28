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
      property :should_draw_bounding_boxes, type: :boolean, default: true

      # @attribute
      # The color of the model name text.
      property :label_color, default: "rgba(255,255,255,1.0)"

      # @attribute
      # The font of the model name label.
      property :font, default: { name: 'Arial', size: 16 }

      # @attribute
      # Sets whether to draw the model name labels
      property :should_draw_labels, type: :boolean, default: true

      # @attribute
      # For actors that have no bounds, like sound or custom models without
      # a position, they are normally hidden but can be shown. Currently they
      # appear all overlapped in the upper-left corner of the screen.
      #
      # @todo when enabled the boundless actors should be presented in a cleaner
      #   way to allow for easier viewing of them.
      property :should_hide_boundless_actors, type: :boolean, default: true

      # Store the labels that are being drawn in the scene. This hash of labels
      # acts as a cache around the items that are being labeled based on the
      # name of the objects that are being labeled.
      def labels
        @labels ||= {}
      end

      def show
        self.saveable_to_view = false
      end

      def update
        scene.drawers.each do |drawer|
          next if (drawer.bounds == Bounds.none and should_hide_boundless_actors)
          label = labels[drawer.name]

          unless label
            label = create "metro::ui::modellabel", target: drawer
            labels[drawer.name] = label
          end

          label.should_draw_label = should_draw_labels
          label.should_draw_bounding_box = should_draw_bounding_boxes
          label.bounds = drawer.bounds
        end

      end

      def draw
        labels.values.each { |label| label.draw }
      end

    end

  end
end