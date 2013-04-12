module Metro
  module UI
    class TileLayer < ::Metro::Model
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

      def draw
        tiles_within_viewport.each do |bounds,image|
          image.draw_rot(bounds.left - x,bounds.top - y,z_order,rotation)
        end
      end

      private

      def tiles_within_viewport
        enlarged_viewport = viewport.enlarge(left: map.tilewidth, right: map.tilewidth, top: map.tileheight, bottom: map.tileheight)
        tile_bounds.find_all {|bounds,images| enlarged_viewport.intersect?(bounds) }
      end

      def tile_bounds
        @tile_bounds ||= build_tiles_index
      end

      def build_tiles_index
        data.each_with_index.map do |image_index,position|
          next if image_index == 0
          image = tileset_image(image_index)
          [ position_of_image(image,row(position),column(position)), image ]
        end.compact
      end

      def tileset_image(image_index)
        unless cached_images[image_index]
          tileset = map.tilesets.find do |t|
            image_index >= t.firstgid && image_index < t.firstgid + t.images.count
          end
          tileset_image_index = image_index - tileset.firstgid
          cached_images[image_index] = tileset.images[tileset_image_index]
        end

        cached_images[image_index]
      end

      def row(position)
        position / layer.width
      end

      def column(position)
        position % layer.width
      end

      def cached_images
        @cached_images ||= {}
      end
    end

  end
end