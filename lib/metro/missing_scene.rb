require_relative 'scene'

module Metro
  class MissingScene < Scene
    scene_name :missing_scene

    class << self
      attr_accessor :missing_scene
    end

    draw :title, text: "Missing Scene!",
      x: 20, y: 20, z_order: 1,
      x_factor: 3, y_factor: 3,
      color: 0xffffffff,
      model: "metro::models::label"

    draw :message, text: 'The scene `#{self.class.missing_scene}` was requested, but is missing!',
      x: 20, y: 100, z_order: 1,
      color: 0xffffffff,
      model: "metro::models::label"

  end
end