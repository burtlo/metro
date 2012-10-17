module Metro
  module Scenes
    extend self

    def scenes
      @scenes ||= Scene.scenes.inject({}) do |dict,scene|
        name = scene.to_s.gsub(/Scene$/,'').downcase.to_sym
        dict[name] = scene
        dict[scene] = scene
        dict
      end
    end

    def find(scene_name)
      scenes[scene_name.to_sym]
    end
    
    def create(scene_name,window)
      find(scene_name).new(window)
    end

  end
end