module Metro
  module UI

    class TileMap < Model

      property :position
      property :file, type: :text
      property :rotation

      def map
        @map ||= begin
          map = Tmxed.parse asset_path(file)
          map.tilesets.each {|tileset| tileset.window = window }
          map
        end
      end

      def draw
        map.layers.each { |layer| draw_layer(layer) }
      end

      private

      def half_tilewidth
        @half_tilewidth ||= map.tilewidth/2
      end

      def half_tileheight
        @half_tileheight ||= map.tileheight/2
      end

      def start_x
        @start_x ||= x + map.tilewidth * map.width / 2
      end

      def x_position(row,column,image_width)
        row_start_x = start_x - half_tilewidth * row - (map.tilewidth - image_width)/2
        row_start_x + half_tilewidth * column
      end

      def start_y
        y
      end

      def y_position(row,column,image_height)
        row_start_y = start_y + half_tileheight * row + (map.tileheight - image_height)/2
        row_start_y + half_tileheight * column
      end

      def image_from_tileset(image_index)
        unless cached_images[image_index]
          tileset = map.tilesets.find {|t| image_index >= t.firstgid && image_index < t.firstgid + t.images.count }
          tileset_image_index = image_index - tileset.firstgid
          cached_images[image_index] = tileset.images[tileset_image_index]
        end

        cached_images[image_index]
      end

      def cached_images
        @cached_images ||= {}
      end

      def draw_layer(layer)
        layer.data.each_with_index do |image_index,position_index|
          next if image_index == 0
          column = position_index % layer.width
          row = position_index / layer.height
          draw_image(image_index,row,column)
        end
      end

      def draw_image(image_index,row,column)
        image = image_from_tileset(image_index)
        point = image_point(image,row,column)
        image.draw_rot(point.x,point.y,z_order,rotation)
      end

      def image_point(image,row,column)
        unless cached_positions[row][column]
          pos_x = x_position(row,column,image.width)
          pos_y = y_position(row,column,image.height)
          cached_positions[row][column] = Point.at(pos_x, pos_y)
        end
        cached_positions[row][column]
      end

      def cached_positions
        @cached_positions ||= begin
          Hash.new do |hash,key|
            hash[key] = {}
          end
        end
      end

    end
  end
end