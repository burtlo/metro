
#
# The asset_path is a helper which will generate a filepath based on the current
# working directory of the game. This allows for game author's to specify a path
# relative within the assets directory of their game.
#
# @note Paths that are defined within views use this helper and are assumed to
#   be paths relative within the assets directory of the game. For images,
#   samples, and songs in a model consider using a property.
#
# @see Metro::Model::ImageProperty
# @see Metro::Model::AnimationProperty
# @see Metro::Model::SongProperty
# @see Metro::Model::SampleProperty
#
# @note Also consider the model classes Image, Animation, Song, and Sample for
#   creating the assets found within the assets folder. Each of those will
#   assist with using the asset_path internally to find the asset.
#
# @see Metro::Image
# @see Metro::Animation
# @see Metro::Song
# @see Metro::Sample
#
# @example Loading a raw Gosu::Image with an `asset_path`
#
#     class Player < Metro::Model
#       def image
#         @image ||= Gosu::Image.new( window, asset_path("player.png"), false )
#       end
#       def draw
#         image.draw_rot(x,y,2,angle)
#       end
#     end
#
def asset_path(name)
  File.join Dir.pwd, "assets", name
end

#
# The metro_asset_path is a helper which will generate a filepath based on the
# directory of the metro library. This is used to retrieve internal assets which
# can be used to serve up missing images, animations, samples, or songs or
# defaults that may come with the metro game library.
#
#
def metro_asset_path(name)
  File.join Metro.asset_dir, name
end

module Metro

  #
  # An AssetPath searches through the various paths based on the path provided.
  #
  # First it assumes the path is absolute, second it assuemts that path is within
  # the game, and third it assumes it is within metro itself.
  #
  class AssetPath

    def self.with(path)
      path.is_a?(AssetPath) ? path : new(path.to_s)
    end

    def initialize(path)
      @path = path
    end

    attr_reader :path

    def filepath
      @filepath ||= begin
        absolute_asset?(path) or game_asset?(path) or metro_asset?(path)
      end
    end

    def absolute_asset?(path)
      asset_at_path? path
    end

    def game_asset?(path)
      asset_at_path? asset_path(path)
    end

    def metro_asset?(path)
      asset_at_path? metro_asset_path(path)
    end

    alias_method :to_s, :filepath

    private

    def asset_at_path?(asset_path)
      asset_path if File.exists?(asset_path) and File.file?(asset_path)
    end
  end
end