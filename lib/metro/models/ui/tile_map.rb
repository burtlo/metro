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

      def y
        viewport.top
      end

      def z_order
        -1
      end

      def viewport=(port)
        @viewport = port
      end

      attr_reader :viewport

      def row(position)
        position / layer.height
      end

      def column(position)
        position % layer.width
      end

      def tiles_at_points
        @tiles_at_points ||= build_tiles_index
      end

      def build_tiles_index
        data.each_with_index.map do |image_index,position|
          next if image_index == 0
          image = tileset_image(image_index)
          [ position_of_image(image,row(position),column(position)), image ]
        end.compact
      end

      def tiles_within_viewport
        tiles_at_points.find_all {|point,images| viewport.contains?(point) }
      end

      def draw
        tiles_within_viewport.each { |point,image| image.draw_rot(point.x - x,point.y - y,z_order,rotation) }
      end

      def tileset_image(image_index)
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
    end

    class TileMapOrthogonalLayer < TileLayer
      def position_of_image(image,row,column)
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

      def position_of_image(image,row,column)
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