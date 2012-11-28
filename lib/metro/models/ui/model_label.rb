module Metro
  module UI

    #
    # The model label will draw a bounding box and label around another model
    #
    # The model label is used by the model labeler which is a facet of the
    # edit scene
    #
    class ModelLabel < Metro::Model

      # Stores the model that is currently being labeled.
      attr_accessor :target

      def bounds=(bounds)
        bounding_box.position = bounds.top_left
        label.position = bounds.top_left + Point.at(4,2,label_z_order)
        label_background.position = label.position - Point.at(2,0,1)
      end

      property :bounding_box_color, type: :color, default: "rgba(255,0,0,0.5)"
      property :font, default: { size: 16 }
      property :label_color, type: :color, default: "rgba(255,255,255,1.0)"
      property :label_background_color, type: :color, default: "rgba(255,0,0,0.5)"

      property :should_draw_bounding_box, type: :boolean, default: true
      property :should_draw_label, type: :boolean, default: true

      property :bounding_box, type: :model do
        create "metro::ui::border", color: bounding_box_color,
          dimensions: target.bounds.dimensions
      end

      property :label, type: :model do
        create "metro::ui::label", text: target.name, font: font,
          position: target.bounds.top_left + Point.at(4,2,label_z_order)
      end

      def label_z_order
        target.respond_to?(:z_order) ? target.z_order + 2 : 0
      end

      property :label_background, type: :model do
        create "metro::ui::rectangle", color: label_background_color,
          position: label.position - Point.at(2,0,1),
          dimensions: label.dimensions + Dimensions.of(6,4)
      end

      def draw
        draw_bounding_box if should_draw_bounding_box
        draw_label if should_draw_label
      end

      def draw_bounding_box
        bounding_box.draw
      end

      def draw_label
        label_background.draw
        label.draw
      end
    end

  end
end