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


      def draw
        scene.drawers.each do |drawer|
          next if (drawer.bounds == Bounds.none and hide_boundless_actors)
          draw_label(drawer) if draw_labels
          draw_bounding_box(drawer) if draw_bounding_boxes
        end
      end

      def draw_label(drawer)
        bounds = drawer.bounds
        z_order = drawer.respond_to?(:z_order) ? drawer.z_order + 1 : 0

        label = create "metro::ui::label", font: font, text: drawer.name,
          position: bounds.top_left + Point.at(4,0,z_order + 1)

        draw_quad(label)
        label.draw
      end

      def draw_quad(label)
        bounds = label.bounds
        window.draw_quad(bounds.left - 4,bounds.top,color,
          bounds.right + 4,bounds.top,color,
          bounds.right + 4,bounds.bottom + 2,color,
          bounds.left - 4,bounds.bottom + 2,color,
          z_order)
      end

      def draw_bounding_box(drawer)
        bounds = drawer.bounds
        window.draw_line bounds.left, bounds.top, color, bounds.right, bounds.top, color, 0
        window.draw_line bounds.right, bounds.top, color, bounds.right, bounds.bottom, color, 0
        window.draw_line bounds.right, bounds.bottom, color, bounds.left, bounds.bottom, color, 0
        window.draw_line bounds.left, bounds.bottom, color, bounds.left, bounds.top, color, 0
      end

    end


  end
end