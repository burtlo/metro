require_relative 'missing_scene'

module Metro

  #
  # @example Finding a scene based on the scene name
  #
  #     class IntroScene < Metro::Scene
  #       # ... scene content ...
  #     end
  #
  #     Scenes.find("intro")    # => IntroScene
  #     Scenes.find(:intro)     # => IntroScene
  #     Scenes.find(IntroScene) # => IntroScene
  #
  # @example Creating a scene instance based on the scene name
  #
  #     class IntroScene < Metro::Scene
  #       # ... scene content ...
  #     end
  #
  #     Scenes.generate("intro")    # => [SCENE: title]
  #     Scenes.generate(:intro)     # => [SCENE: title]
  #     Scenes.generate(IntroScene) # => [SCENE: title]
  #
  module Scenes
    extend self

    #
    # Finds the scene based on the specified scene name.
    #
    # @param [String,Symbol] scene_name the name of the scene to locate.
    # @return the Scene class that is found matching the specified scene name.
    #
    def find(scene_name)
      found_scene = scenes_hash[scene_name]

      unless found_scene
        found_scene = create_missing_scene(scene_name)
      end

      found_scene
    end

    def create_missing_scene(scene_name)
      MissingScene.missing_scene = scene_name
      MissingScene
    end

    #
    # Finds the scene with the specified name and then creates an instance of that
    # scene.
    #
    # @param [String,Symbol] scene_name the name of the scene to locate.
    # @return an instance of Scene that is found matching the specified scene name
    #
    def generate(scene_name)
      find(scene_name).new
    end

    private

    #
    # @return a Hash that allows for accessing  symbol names of the scenes
    #   as well as the class name constants to allow for the scenes to be found.
    #
    def scenes_hash
      @scenes_hash ||= Scene.scenes.inject({}) do |dict,scene|
        name = scene.scene_name
        dict[name] = scene
        dict[name.to_sym] = scene
        dict[scene] = scene
        dict
      end
    end

  end
end