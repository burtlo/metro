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
  #
  # @example Creating a scene instance based on the scene name
  #
  #     class IntroScene < Metro::Scene
  #       # ... scene content ...
  #     end
  #
  #     Scenes.generate("intro")    # => [SCENE: title]
  #     Scenes.generate(:intro)     # => [SCENE: title]
  #
  # @example Finding a scene that does not exist
  #
  #     scene = Scenes.find(:unknown)
  #     scene.missing_scene            # => :unknown
  #
  module Scenes
    extend self

    #
    # Add a scene to the hash of scenes with the scene name of the scene as the key
    # to retrieving this scene.
    #
    # @param [Scene] scene the scene to be added to the hash of Scenes.
    #
    def add_scene(scene)
      all_scenes_for(scene).each { |scene| scenes_hash[scene.scene_name] = scene.to_s }
    end

    #
    # Finds the scene based on the specified scene name.
    #
    # @param [String,Symbol] scene_name the name of the scene to locate.
    # @return the Scene class that is found matching the specified scene name.
    #
    def find(scene_name)
      scene_class( scenes_hash[scene_name] )
    end

    #
    # Finds the scene with the specified name and then creates an instance of that
    # scene.
    #
    # @param [String,Symbol,Object] scene_name the name of the scene to locate.
    # @return an instance of Scene that is found matching the specified scene name
    #
    def generate(scene_or_scene_name,options = {})
      new_scene = generate_scene_from(scene_or_scene_name)
      apply_post_filters(new_scene,options)
    end

    #
    # If we have been given a scene, then we simply want to use it otherwise
    # we need to find and generate our scene from the scene name.
    #
    # @param [String,Sybmol,Class] scene_or_scene_name the name of the scene or an instance
    #   of Scene.
    #
    def generate_scene_from(scene_or_scene_name)
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
      @post_filters ||= []
    end

    #
    # Register a filter that will be executed after a scene is found and generated. This
    # allows for the scene to be modified or changed based on the provided options.
    #
    # A filter is any object that responds to #filter and accepts two parameters: the
    # scene and a hash of options.
    #
    # @param [#filter] post_filter a filter is an object that can act as a filter.
    #
    def register_post_filter(post_filter)
      post_filters.push(post_filter)
    end

    private

    #
    # Apply all the post filtering to the specified scene with the given options
    #
    # @return a Scene object that has been filtered.
    #
    def apply_post_filters(new_scene,options)
      post_filters.inject(new_scene) {|scene,post| post.filter(scene,options) }
    end

    #
    # @return a Hash that allows for accessing  symbol names of the scenes
    #   as well as the class name constants to allow for the scenes to be found.
    #
    def scenes_hash
      @scenes_hash ||= hash_with_missing_scene_default
    end

    #
    # Create a hash that will return a setup missing scene by default.
    #
    def hash_with_missing_scene_default
      hash = HashWithIndifferentAccess.new do |hash,key|
        missing_scene = scene_class(hash[:missing_scene])
        missing_scene.missing_scene = key.to_sym
        missing_scene
      end
      hash[:missing_scene] = "Metro::MissingScene"
      hash
    end

    #
    # Returns all subclassed scenes of the scene or scenes provided. This method is
    # meant to be called recursively to generate the entire list of all the scenes.
    #
    # @param [Scene,Array<Scene>] scenes a scene or scene subclass or an array of
    #   scene subclasses.
    #
    def all_scenes_for(scenes)
      Array(scenes).map do |scene_class_name|
        scene = scene_class(scene_class_name)
        [ scene ] + all_scenes_for(scene.scenes)
      end.flatten.compact
    end

    #
    # @param [String,Symbol] class_name the name of the class that you want the class
    #
    # @return the class with the given class name
    #
    def scene_class(class_or_class_name)
      class_or_class_name.class == Class ? class_or_class_name : class_or_class_name.constantize
    end

  end
end

require_relative 'transitions/scene_transitions'