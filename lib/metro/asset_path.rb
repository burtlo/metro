#
# The asset_path is a helper which will generate a filepath based on the current working
# directory of the game. This allows for game author's to specify a path relative within
# the assets directory of their game.
# 
# @note Paths that are defined within views use this helper and are assumed to be paths
#   relative within the assets directory of the game.
# 
# @example Loading the branding image for the player model.
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
