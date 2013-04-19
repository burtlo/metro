module Metro
  module UI
    class TileMap < ::Metro::Model

      property :file, type: :text
      property :rotation

      property :follow, type: :text

      attr_accessor :layers
      attr_accessor :viewport

      def map
        @map ||= begin
          map = ::Tmx.load asset_path(file)
          map.tilesets.each {|tileset| tileset.window = window }
          map
        end
      end

      def objects(*types)
        result = map.object_groups.map do |object_group|
          types.map do |type|
            # TODO: provide a more robust query functionality in the TMX gem
            object_group.objects.find_all {|object| object.type == type }
          end
        end.flatten.compact
      end

      def show
        self.layers = map.layers.collect do |layer|
          tml = TileLayer.new
          # FIX: change to use composition
          tml.extend layer_positioning
          tml.rotation = rotation
          tml.viewport = viewport
          tml.map = map
          tml.layer = layer
          tml.tilesets = map.tilesets
          tml
        end
      end

      def update
        shift_viewport_to_center_who_we_are_following
      end

      def draw
        layers.each {|layer| layer.draw }
      end

      private

      def layer_positioning
        { orthogonal: "Metro::Tmx::TileLayer::OrthogonalPositioning",
          isometric: "Metro::Tmx::TileLayer::IsometricPositioning" }[map.orientation.to_sym].constantize
      end

      def following
        scene.send(follow) if follow
      end

      def shift_viewport_to_center_who_we_are_following
        return unless following

        diff_x = (following.x - Game.center.x).to_i

        if diff_x >= 1 or diff_x <= -1
          viewport.shift(Point.at(diff_x,0))
        end

      end

    end
  end
end

require_relative 'tmx/tile_layer'
require_relative 'tmx/isometric_position'
require_relative 'tmx/orthogonal_position'