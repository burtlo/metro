module Metro
  module UI

    class ModelLabeler < Metro::Model

      property :color, default: "rgba(255,0,0,0.5)"
      property :label_color, default: "rgba(255,255,255,1.0)"
      property :font, default: { name: 'Arial', size: 16 }
      property :position, default: Point.zero

      property :draw_labels, type: :boolean, default: true
      property :draw_bounding_boxes, type: :boolean, default: true

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
        z_order = drawer.respond_to?(:z_order) ? drawer.z_order + 1 : 0

        label = create "metro::ui::label", font: font, text: drawer.name,
          position: bounds.top_left + Point.at(4,2,z_order)

        draw_quad_behind(label)
        label.draw
      end

      def draw_quad_behind(drawer)
        quad = create "metro::ui::rectangle",
          position: drawer.position - Point.at(4,0) + Point.at(2,0,-2),
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