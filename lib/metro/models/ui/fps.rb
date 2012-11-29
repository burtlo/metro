module Metro
  module UI

    class FPS < Metro::Model

      property :placement, type: :text, default: 'top'
      property :color, default: "rgba(255,255,255,1.0)"

      property :label, type: :model do
        create "metro::ui::label", text: "FPS: 0", color: color
      end

      def valid_placements
        @valid_placements ||= begin
          {
           top_left:     { position: Game.bounds.top_left, align: 'left', vertical_align: 'top' },
           top:          { position: Point.at(Game.center.x, Game.bounds.top), align: 'center', vertical_align: 'top' },
           top_right:    { position: Game.bounds.top_right, align: 'right', vertical_align: 'top' },
           right:        { position: Point.at(Game.bounds.right, Game.center.y), align: 'right', vertical_align: 'center' },
           bottom_right: { position: Game.bounds.bottom_right, align: 'right', vertical_align: 'bottom' },
           bottom:       { position: Point.at(Game.center.y, Game.bounds.bottom), align: 'right', vertical_align: 'bottom' },
           bottom_left:  { position: Game.bounds.bottom_right, align: 'left', vertical_align: 'bottom' },
           left:         { position: Point.at(Game.bounds.left, Game.center.y), align: 'left', vertical_align: 'center' }
          }
        end

        @valid_placements.default = :top
        @valid_placements
      end

      def show
        place_label
      end

      def place_label
        placement_hash = valid_placements[placement.to_sym]
        
        label.align = placement_hash[:align]
        label.vertical_align = placement_hash[:vertical_align]
        label.position = placement_hash[:position]
      end

      def update
        label.text = "FPS: #{Gosu.fps}"
      end

      def draw
        label.draw
      end

    end

  end
end