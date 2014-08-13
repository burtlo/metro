module Metro
  module UI
    #
    # Draws a TileMap within the scene.
    #
    # @example Creating a tile map with a Tiled TMX file
    #
    #     class MainScene < GameScene
    #       draw :tile_map, model: "metro::ui::tile_map",
    #         file: "first_level.tmx"
    #     end
    #
    # The viewport, or camera, of the TileMap is static but
    # can be set to follow a particular actor within the scene.
    # The viewport will continue to move according to the position
    # of the specified actor.
    #
    # @example Creating a tile map that will follow the hero
    #
    #     class MainScene < GameScene
    #       draw :hero
    #       draw :tile_map, model: "metro::ui::tile_map",
    #         file: "first_level.tmx", follow: :hero
    #     end
    #
    #
    class TileMap < ::Metro::Model

      # @attribute
      # The Tiled File (*.tmx) that will be parsed and loaded for the tile map
      property :file, type: :text

      # @attribute
      # The actor that the viewport of the scene will follow.
      property :follow, type: :text, default: ""

      # @attribute
      # The rotation of each tile within the scene. This is by default
      # 0 and should likely remain 0.
      property :rotation

      #
      # Return the viewport for the map. The default viewport will be
      # the dimensions of the current Game.
      #
      # @return [RectangleBounds] the bounds of the current viewport
      def viewport
        @viewport ||= Game.bounds
      end

      # @attribute
      # Set the viewport of the map, by default ths viewport will be
      # the dimensions of the current Game, so this may not be
      # necessary to set.
      attr_writer :viewport

      #
      # @return [TMX::Map] the map object found in the specified TMX file.
      #
      def map
        @map ||= begin
          map = ::Tmx.load asset_path(file)
          map.tilesets.each {|tileset| tileset.window = window }
          map
        end
      end

      #
      # Find objects that match the specified type or by the specified
      # parameters. If no parameter is provided then all the objects are
      # returned
      #
      # @example Finding all the objects with the type :floor
      #
      #    objects(:floor)
      #
      # @example Finding all the objects with the name 'tree'
      #
      #    objects(name: 'tree')
      def objects(params=nil)
        params ? map.objects.find(params) : map.objects
      end

      def update
        shift_viewport_to_center_who_we_are_following
      end

      def draw
        layers.each {|layer| layer.draw }
      end

      private

      def layers
        @layers ||= map.layers.collect do |layer|
          tml = TileLayer.new
          tml.extend layer_positioning
          tml.rotation = rotation
          tml.viewport = viewport
          tml.map = map
          tml.layer = layer
          tml.tilesets = map.tilesets
          tml
        end
      end

      def layer_positioning
        { orthogonal: "Metro::Tmx::TileLayer::OrthogonalPositioning",
          isometric: "Metro::Tmx::TileLayer::IsometricPositioning" }[map.orientation.to_sym].constantize
      end

      def following
        scene.send(follow) if follow.present?
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