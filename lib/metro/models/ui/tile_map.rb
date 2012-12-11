module Metro
  module UI

    class TileLayer < Model
      property :rotation

      attr_accessor :map
      attr_accessor :layer
      attr_accessor :tilesets

      def data
        layer.data
      end

      def x
        viewport.left
      end

      def z_order
        -1
      end

      def y
        viewport.top
      end

      def viewport=(port)
        @viewport = port
        @viewport.add_change_listener(self)
      end

      attr_reader :viewport

      def bounds_changed(bounds)
      end

      def tiles_at_points
        @tiles_at_points ||= begin
          data.each_with_index.map do |image_index,position_index|
            next if image_index == 0
            column = position_index % layer.width
            row = position_index / layer.height
            image = image_from_tileset(image_index)
            point = image_point(image,row,column)
            [ point, image ]
          end.compact
        end
      end

      def draw
        tiles_at_points.each do |point,image|
          next unless viewport.contains?(point)
          image.draw_rot(point.x - x,point.y - y,z_order,rotation)
        end
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

      def image_point(image,row,column) ; end

    end

    class TileMapOrthogonalLayer < TileLayer
      def image_point(image,row,column)
        pos_x = x + column * map.tilewidth
        pos_y = y + row * map.tileheight
        Units::Point.at(pos_x, pos_y)
      end
    end

    class TileMapIsometricLayer < TileLayer
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

      def image_point(image,row,column)
        pos_x = x_position(row,column) - (map.tilewidth - image.width)/2
        pos_y = y_position(row,column) + (map.tileheight - image.height)/2
        Units::Point.at(pos_x, pos_y)
      end
    end


    class TileMap < Model

      property :position
      property :file, type: :text
      property :rotation

      attr_accessor :layers
      attr_accessor :viewport

      def map
        @map ||= begin
          map = Tmxed.parse asset_path(file)
          map.tilesets.each {|tileset| tileset.window = window }
          map
        end
      end

      def layer_class
        { orthogonal: "Metro::UI::TileMapOrthogonalLayer",
          isometric: "Metro::UI::TileMapIsometricLayer" }[map.orientation.to_sym].constantize
      end

      def show
        self.layers = map.layers.collect do |layer|
          tml = layer_class.new
          tml.rotation = rotation
          tml.viewport = viewport
          tml.map = map
          tml.layer = layer
          tml.tilesets = map.tilesets
          tml
        end
      end

      def update
        # update the layer with the current viewport position
      end

      def draw
        layers.each {|layer| layer.draw }
      end
    end
  end
end