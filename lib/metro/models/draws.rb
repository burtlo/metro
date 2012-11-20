require_relative 'model_factory'

module Metro
  module Draws

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      #
      # Define an actor with the given name and options.
      #
      # As a convenience the draw method will define `getter` and `setter`
      # methods for the specified actor.
      #
      # @example Defining a title label within a scene
      #
      #     class ExampleScene
      #       draw :title, text: Title Screen',
      #         'model' => 'metro::ui::label'
      #         position: "20,20,0",
      #         scale: "3,3",
      #         color: "rgba(255,255,255,1.0)"
      #
      #       def show
      #         puts "Where is my title? #{title.x},#{title.y}"
      #       end
      #     end
      #
      def draw(actor_name,options = {})

        view_content_for_actor = view.content[actor_name.to_s]

        actor_data = view_content_for_actor.merge(options)
        actor_data[:name] = actor_name

        scene_actor = ModelFactory.new actor_name, actor_data

        define_method actor_name do
          instance_variable_get("@#{actor_name}")
        end

        define_method "#{actor_name}=" do |value|
          instance_variable_set("@#{actor_name}",value)
        end

        drawings.push scene_actor
      end

      #
      # Define a sound actor with the given anem and options.
      #
      # @see #draw
      #
      def play(song_name,options={})
        draw song_name, options.merge(model: "metro::audio::song")
      end

      #
      # Define several actors to be drawn.
      #
      def draws(*actor_names)
        actor_names = actor_names.flatten.compact

        actor_names.each do |actor_name|
          draw actor_name
        end

        drawings
      end

      #
      # All of the model factories that have been defined.
      #
      def drawings
        @drawings ||= []
      end

      alias_method :actors, :drawings

    end

  end
end
