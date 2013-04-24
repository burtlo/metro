module Metro
  module Tmx
    class TileLayer

      module IsometricPositioning

        def position_of_image(image,row,column)
          pos_x = x_position(row,column) - (map.tilewidth - image.width)/2
          pos_y = y_position(row,column) + (map.tileheight - image.height)/2
          ::Metro::Units::Bounds.new left: pos_x, top: pos_y, right: pos_x + map.tilewidth, bottom: pos_y + map.tileheight
        end

        def half_tilewidth
          @half_tilewidth ||= map.tilewidth/2
        end

        def half_tileheight
          @half_tileheight ||= map.tileheight/2
        end

        def start_x
          @start_x ||= x + map.tilewidth * map.width / 2
        end

        def x_position(row,column)
          row_start_x = start_x - half_tilewidth * row
          row_start_x + half_tilewidth * column
        end

        def start_y
          y
        end

        def y_position(row,column)
          row_start_y = start_y + half_tileheight * row
          row_start_y + half_tileheight * column
        end

      end

    end
  end
end