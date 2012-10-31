require_relative 'transitions/scene_transitions'

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
      
      if found_scene
        ActiveSupport::Dependencies.constantize found_scene
      else
        create_missing_scene(scene_name)
      end
    end

    def create_missing_scene(scene_name)
      MissingScene.missing_scene = scene_name
      MissingScene
    end

    #
    # Finds the scene with the specified name and then creates an instance of that
    # scene.
    #
    # @param [String,Symbol,Object] scene_name the name of the scene to locate.
    # @return an instance of Scene that is found matching the specified scene name
    #
    def generate(scene_or_scene_name,options = {})
      new_scene = use_scene_or_generate_scene(scene_or_scene_name)

      post_filters.inject(new_scene) {|scene,post| post.filter(scene,options) }
    end

    #
    # If we have been given a scene, then we simply want to use it otherwise
    # we need to find and generate our scene from the scene name.
    # 
    def use_scene_or_generate_scene(scene_or_scene_name)
      if scene_or_scene_name.is_a? Scene
        scene_or_scene_name
      else
        find(scene_or_scene_name).new
      end
    end

    #
    # Post filters are applied to the scene after it has been found. These are
    # all objects that can respond to the #filter method.
    # 
    def post_filters
      [ SceneTransitions ]
    end

    private

    #
    # @return a Hash that allows for accessing  symbol names of the scenes
    #   as well as the class name constants to allow for the scenes to be found.
    #
    def scenes_hash
      @scenes_hash ||= Scene.scenes.inject({}) do |dict,scene_classname|
        scene = ActiveSupport::Dependencies.constantize scene_classname
        name = scene.scene_name
        dict[name] = scene
        dict[name.to_sym] = scene
        dict[scene] = scene
        dict
      end
    end

  end
end