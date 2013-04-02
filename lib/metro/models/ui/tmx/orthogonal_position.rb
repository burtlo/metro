module Metro
  module Tmx
    class TileLayer

      module OrthogonalPositioning
        def position_of_image(image,row,column)
          pos_x = x + column * map.tilewidth + map.tilewidth / 2
          pos_y = y + row * map.tileheight + map.tileheight / 2
          Bounds.new left: pos_x, top: pos_y, right: pos_x + map.tilewidth, bottom: pos_y + map.tileheight/2
        end
      end

    end
  end
end