module Metro
  module Models
    
    class GridDrawer < Model

      property :color, default: "rgba(255,255,255,0.1)"
      property :spacing, type: :numeric, default: 10

      attr_writer :spacing, :height, :width

      def name
        self.class.name
      end

      def height
        @height || Game.height
      end

      def width
        @width || Game.width
      end

      def saveable?
        false
      end

      def contains?(x,y)
        false
      end

      def draw
        draw_horizontal_lines
        draw_vertical_lines
      end

      def draw_vertical_lines
        xs = (width / spacing + 1).times.map {|segment| segment * spacing }
        xs.each do |x|
          window.draw_line(x, 1, color, x, height, color, 0, :additive)
        end
      end

      def draw_horizontal_lines
        ys = (height / spacing + 1).times.map {|segment| segment * spacing }
        ys.each do |y|
          window.draw_line(1, y, color, width, y, color, 0, :additive)
        end
      end

    end
  end
end