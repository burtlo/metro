require_relative 'animation_factory'

module Metro
  module HasAnimations

    def self.included(base)
      base.extend ClassMethods
    end

    #
    # Define an animation from within another animation block, an event block
    # or a method.
    #
    # @example Defining an animation that fades out the hero when they have
    #   died.
    #
    #     class HellScene
    #       draws :hero
    #
    #       def update
    #         if hero.dead?
    #           animate :hero, to: { alpha: 0 }, interval: 60.ticks do
    #             transition_to :game_over
    #           end
    #         end
    #       end
    #
    #     end
    #
    def animate(actor_or_actor_name,options,&block)
      options[:actor] = actor(actor_or_actor_name)
      options[:context] = self
      animation_group = SceneAnimation.build options, &block
      enqueue animation_group
    end

    # An alternative to stating `animate` syntax.
    alias_method :change, :animate

    module ClassMethods

      #
      # Define an animation to execute when the scene starts.
      #
      # @example Defining an animation that fades in and moves a logo when it is
      #   done, transition to the title scene.
      #
      #     animate :logo, to: { y: 80, alpha: 50 }, interval: 120.ticks do
      #       transition_to :title
      #     end
      #
      def animate(actor_name,options,&block)
        scene_animation = AnimationFactory.new actor_name, options, &block
        animations.push scene_animation
      end

      # Provide an alternative to the `animate` syntax.
      alias_method :change, :animate

      #
      # All the animations that are defined for the scene to be run the scene starts.
      #
      def animations
        @animations ||= []
      end

    end

  end
end