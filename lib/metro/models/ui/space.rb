module Metro
  module UI

    #
    # Adds a 2D Physics Space to the Scene
    #
    # @see http://beoran.github.io/chipmunk/
    #
    # @example Adding a space to the scene
    #
    #     class MainScene < GameScene
    #       draw :space, model: "metro::ui::space"
    #       draw :hero, position: Game.center
    #
    #       def show
    #         space.add_object(hero)
    #         space.gravity_affects(hero)
    #       end
    #
    #       def update
    #         space.step
    #         space.clean_up
    #       end
    #     end
    #
    # Adding a space to a scene allows for objects with a
    # `body` and `shape` to be added and affected by
    # collisions and gravity.
    #
    class Space < Model

      # @attribute
      # Amount of viscous damping to apply to the space. A value of 0.9 means
      # that each body will lose 10% of it’s velocity per second. Defaults to 1.
      # Like gravity can be overridden on a per body basis.
      property :damping, default: 0.5

      # @attribute
      # Each update cycle the space will perform a number of steps equal to
      # this value. The higher the value the better the resolution will be for
      # collisions between objects, the lower the value the sloppier the
      # resolution will be for collisions.
      property :sampling_per_update, default: 6

      # @attribute
      # The amount of time the space should be stepped. This step value is
      # multiplied by the #sampling_per_update value.
      property :delta, default: (1.0/60.0)

      # @attribute
      # The amount of gravitationl force to apply to bodies within the space.
      # This is by default a force at the center of the object applied downward.
      property :gravitational_forces, type: :array,
        default: [ CP::Vec2.new(0,1000), CP::Vec2.new(0,0) ]

      # Add a single object to the space. This object will have a reference
      # stored here and it's body and shape added to the space so that it
      # collide with other objects added to the space.
      #
      # @param [Object<#body,#shape>] object add a new object to the space. The
      #   object has a `body` and a `shape`.
      #
      def add_object(object)
        space_objects.push(object)
        space.add_body object.body
        space.add_shape object.shape
      end

      # Remove a single object from the space. This object will remove the
      # reference stored within the space as well as removing the body and
      # shape that was added to the space.
      #
      def remove_object(object)
        space_objects.delete(object)
        space.remove_body(object.body)
        space.remove_shape(object.shape)
      end

      # Add multiple objects to the space.
      # @see #add_object
      def add_objects(objects)
        Array(objects).each {|object| add_object(object) }
      end

      # When the first shape collides with the second shape perform
      # the following block of code.
      def collision_between(first,second,&block)
        space.add_collision_func(first,second,&block)
      end

      # This method allows the space to declare which objects are effected by
      # gravity during their time within the space.
      #
      # @note for the object to be affected by gravity it still needs to be
      #   added to the space first.
      #
      def gravity_affects(object)
        victims_of_gravity.push object
      end

      # Access to the raw Chimpmunk Space object
      # @see http://beoran.github.io/chipmunk/#Space
      attr_reader :space


      # This method needs to be called each update loop. This will update and
      # move all the objects currently within the space and start the resolution
      # of collisions.
      def step
        sampling_per_update.to_i.times { space.step(delta) }
      end

      # This method needs to be called each update loop. This will reset all
      # the forces on the existing objects. This essentially keeps them from
      # accelerating out of control. It will also rebuild the shape positioning
      # for collisions. In a static frame, the level does not scroll, the
      # rebuiling is not necessary, but for levels where it moves this is
      # important.
      #
      def clean_up
        space_objects.each {|object| object.body.reset_forces }
        space.rehash_static
      end

      def show
        @space = CP::Space.new
        @space.damping = damping
      end

      def update
        apply_gravity_to victims_of_gravity
      end

      # @return [Array<Object>] a list of objects currently mantained by the
      #   space.
      def space_objects
        @space_objects ||= []
      end

      # @return [Array<Object>] all of the objects that are affected by gravity
      def victims_of_gravity
        @victims_of_gravity ||= []
      end

      # Apply gravity to the specified objects.
      def apply_gravity_to(objects)
        objects.each {|object| object.body.apply_force *gravitational_forces }
      end

    end
  end
end
