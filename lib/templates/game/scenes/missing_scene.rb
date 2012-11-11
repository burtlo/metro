
#
# The missing scene is called when transitioning to a scene that does not exist.
# 
# This is not mandatory as Metro maintains this missing scene. However, this is useful
# if you want to override the look and interaction for the player when a scene does missing.
# 
# class Metro::MissingScene < Metro::Scene
#   scene_name :missing_scene
# 
#   class << self
#     attr_accessor :missing_scene
#   end
# 
#   draw :title, text: "Missing Scene!",
#     position: "20,20,1",
#     color: "rgb(255,0,0)",
#     font: {size: 80},
#     model: "metro::models::label"
# 
#   draw :message, text: 'The scene `#{self.class.missing_scene}` was requested, but is missing!',
#     position: "20,100,1",
#     color: "rgb(255,255,255)",
#     model: "metro::models::label"
# 
# end