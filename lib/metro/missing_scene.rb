module Metro
  class MissingScene < Scene
    scene_name :missing_scene

    class << self
      attr_accessor :missing_scene
    end

    draw :title, text: "Missing Scene!",
      position: "20,20,1",
      color: 0xffffffff,
      font: {size: 40},
      model: "metro::models::label"

    draw :message, text: 'The scene `#{self.class.missing_scene}` was requested, but is missing!',
      position: "20,100,1",
      color: 0xffffffff,
      model: "metro::models::label"

  end
end
