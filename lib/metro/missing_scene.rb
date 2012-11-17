module Metro
  class MissingScene < Scene
    scene_name :missing_scene

    class << self
      attr_accessor :missing_scene
    end

    draw :title, text: "Missing Scene!",
      position: "20,20,1",
      color: "rgb(255,0,0)",
      font: {size: 80},
      model: "metro::ui::label"
    
    draw :message, text: 'The scene `#{self.class.missing_scene}` was requested, but is missing!',
      position: "20,100,1",
      color: "rgb(255,255,255)",
      model: "metro::ui::label"

  end
end
