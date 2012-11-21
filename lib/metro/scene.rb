require_relative 'views/scene_view'

require_relative 'events/has_events'
require_relative 'events/event_relay'
require_relative 'events/unknown_sender'

require_relative 'models/draws'

require_relative 'animation/has_animations'
require_relative 'animation/scene_animation'
require_relative 'animation/after_interval_factory'

module Metro

  #
  # A scene is a basic unit of a game. Within a scene you define a number of methods
  # that handle the initial setup, event configuration, logic updating, and drawing.
  #
  # @see #show
  # @see #update
  # @see #draw
  # @see #events
  #
  # A fair number of private methods within Scene are prefaced with an underscore.
  # These methods often call non-underscored methods within those methods. This allows
  # for scene to configure or perform some functionality, while providing an interface
  # so that every subclass does not have to constantly call `super`.
  #
  class Scene
    include Units

    #
    # As Scene does a lot of work for you with regarding to setting up content, it is
    # best not to override #initialize and instead define an #after_initialize method
    # within the subclasses of Scene.
    #
    # @note This method should be implemented in the Scene subclass.
    #
    def after_initialize ; end

    #
    # This method is called right after the scene has been adopted by the window
    #
    # @note This method should be implemented in the Scene subclass.
    #
    def show ; end

    #
    # This is called every update interval while the window is being shown.
    #
    # @note This method should be implemented in the Scene subclass.
    #
    def update ; end

    #
    # This is called after every {#update} and when the OS wants the window to
    # repaint itself.
    #
    # @note This method should be implemented in the Scene subclass.
    #
    def draw ; end

    #
    # Before a scene is transisitioned away from to a new scene, this method is called
    # to allow for the scene to complete any taskss, stop any actions, or pass any
    # information from the existing scene to the scene that is about to replace it.
    #
    # @note This method should be implemented in the Scene subclass.
    #
    # @param [Scene] new_scene this is the instance of the scene that is about to replace
    #   the current scene.
    #
    def prepare_transition_to(new_scene) ; end

    #
    # Before a scene is transisitioned to it is called with the previous scene. This
    # allows for the new scene to rerieve any data from the previous scene to assist
    # with the layout of the current scene.
    #
    # @note This method should be implemented in the Scene subclass.
    #
    # @param [Scene] old_scene this is the instance of the scene that is being moved
    #   away from.
    #
    def prepare_transition_from(old_scene) ; end

    include Draws

    #
    # When an actor is defined, through the class method `draw` a getter and setter method
    # is defined. However, it is a better interface internally not to rely heavily on send
    # and have this small amount of obfuscation in the event that this needs to change.
    #
    # @return the actor with the given name.
    #
    def actor(actor_or_actor_name)
      if actor_or_actor_name.is_a? String or actor_or_actor_name.is_a? Symbol
        send(actor_or_actor_name)
      else
        actor_or_actor_name
      end
    end

    #
    # Post a custom notification event. This will trigger any objects that are listening
    # for custom events.
    #
    def notification(event,sender=nil)

      sender = sender || UnknownSender

      event_relays.each do |relay|
        relay.fire_events_for_notification(event,sender)
      end
    end

    #
    # A scene has events which it will register when the window is established.
    #
    include HasEvents

    #
    # A scene defines animations which it will execute when the scene starts
    #
    include HasAnimations

    #
    # Allow the definition of a updater that will be executed when the scene starts.
    #
    # @example Setting up an event to 2 seconds after the scene has started.
    #
    #     class ExampleScene
    #
    #       draws :title
    #
    #       after 2.seconds do
    #         transition_to :next_scene
    #       end
    #     end
    #
    def self.after(ticks,&block)
      after_intervals.push AfterIntervalFactory.new ticks, &block
    end

    #
    # Perform an operation after the specified interval.
    #
    #     class ExampleScene
    #
    #       draws :player
    #
    #       def update
    #         if player.is_dead?
    #           after 2.seconds do
    #             transition_to :game_over
    #           end
    #         end
    #       end
    #
    #     end
    #
    def after(ticks,&block)
      tick = OnUpdateOperation.new interval: ticks, context: self
      tick.on_complete(&block)
      enqueue tick
    end

    #
    # Setups up the Actors for the Scene based on the ModelFactories that have been
    # defined.
    #
    # @note this method should not be overriden, otherwise the actors will perish!
    # @see #after_initialize
    #
    def initialize
      add_actors_to_scene
      after_initialize
    end

    def add_actors_to_scene
      self.class.actors.each do |scene_actor|
        actor_instance = scene_actor.create
        actor_instance.scene = self
        send "#{scene_actor.name}=", actor_instance
      end
    end

    #
    # The window is the main instance of the game. Using window can access a lot of
    # underlying Metro::Window, a subclass of Gosu::Window, that the Scene class is
    # obfuscating.
    #
    # @see Metro::Window
    # @see Gosu::Window
    #
    attr_reader :window

    #
    # Setting the window places the scene within in the specified window. Which
    # will cause a number of variables and settings to be set up. The {#show}
    # method is called after the window has been set.
    #
    def window=(window)
      @window = window

      event_relays.clear

      register_events!
      register_actors!
      register_animations!
      register_after_intervals!

      show
    end

    #
    # Register all the events that were defined for this scene.
    #
    def register_events!
      register_events_for_target(self,self.class.events)
    end

    #
    # Register all the actors that were defined for this scene.
    #
    def register_actors!
      self.class.actors.each { |actor| register_actor(actor) }
    end

    #
    # Register all the animations that were defined for this scene.
    #
    def register_animations!
      self.class.animations.each do |animation|
        animate animation.actor, animation.options, &animation.on_complete_block
      end
    end

    def register_after_intervals!
      self.class.after_intervals.each do |after_interval|
        after after_interval.ticks, &after_interval.block
      end
    end

    #
    # Registering an actor involves setting up the actor within
    # the window, adding them to the list of things that need to be
    # drawn and then registering any eventst that they might have.
    #
    def register_actor(actor_factory)
      registering_actor = actor(actor_factory.name)
      registering_actor.window = window
      registering_actor.show

      drawers.push(registering_actor)
      updaters.push(registering_actor)

      register_events_for_target(registering_actor,registering_actor.class.events)
    end

    #
    # Allows you to set or retrieve the scene name for the Scene.
    #
    # @example Retrieving the default scene name
    #
    #     class ExampleScene < GameScene
    #     end
    #
    #     ExampleScene.scene_name # => "example"
    #
    # @example Setting a custom name for the Scene
    #
    #     class RollingCreditsScene < GameScene
    #       scene_name "credits"
    #     end
    #
    #     RollingCreditsScene.scene_name # => "credits"
    #
    # @param [String] scene_name when specified it will set the scene name for the class
    #   to the value specified.
    #
    # @return the String name of the scene which it can be used as a reference for transitioning
    #   or for generating the appropriate view information.
    #
    def self.scene_name(scene_name=nil)
      @scene_name ||= begin
        if to_s == "Metro::Scene"
          to_s.underscore
        else
          to_s.gsub(/_?Scene$/i,'').underscore
        end
      end

      scene_name ? @scene_name = scene_name.to_s : @scene_name
    end

    #
    # @return a common name that can be used through the system as a common identifier.
    #
    def self.metro_name
      scene_name
    end

    #
    # @return an array of all the scene names of all the ancestor scenes
    #
    def self.hierarchy
      ancestors.find_all {|a| a.respond_to? :metro_name }.map(&:metro_name)
    end

    #
    # Allows you to set or retrieve the scene name for the Scene.
    #
    # @example Retrieving the default scene name
    #
    #     class ExampleScene
    #       def show
    #         puts "Showing Scene: #{self.scene_name}" # => Showing Scene: example
    #       end
    #     end
    #
    # @return the string name of the Scene.
    #
    def scene_name
      self.class.scene_name
    end

    #
    # @return the string representation of a scene, this is used for debugging.
    #
    def to_s
      "[SCENE: #{self.class.scene_name}(#{self.class})]"
    end

    #
    # Captures all classes that subclass Scene.
    #
    # @see #self.scenes
    #
    def self.inherited(base)
      scenes << base.to_s
      Scenes.add_scene(base)
    end

    #
    # All subclasses of Scene, this should be all the defined scenes within the game.
    #
    # @return an Array of Scene subclasses
    #
    def self.scenes
      @scenes ||= []
    end

    #
    # Enqueue will add an updater to the list of updaters that are run initially when
    # update is called. An updater is any object that can respond to #update. This
    # is used for animations.
    #
    def enqueue(updater)
      updaters.push(updater)
    end

    #
    # The class defined updaters which will be converted to instance updaters when the scene
    # has started.
    #
    def self.after_intervals
      @after_intervals ||= []
    end

    #
    # The objects that need to be executed on every update. These objects are traditionally
    # animations or window events for held pressed buttons. But can be any objects that responds
    # to the method #update.
    #
    def updaters
      @updaters ||= []
    end

    #
    # The `base_update` method is called by the Game Window. This is to allow for any
    # special update needs to be handled before calling the traditional `update` method
    # defined in the subclassed Scene.
    #
    def base_update
      updaters.each { |updater| updater.update }
      update
      updaters.reject! { |updater| updater.completed? }
    end

    #
    # The objects that need to be drawn with every draw cycle. These objects are traditionally
    # the model objects, like the actors defined within the scene.
    #
    def drawers
      @drawers ||= []
    end

    #
    # The `base_draw` method is called by the Game Window. This is to allow for any
    # special drawing needs to be handled before calling the traditional `draw` method
    # defined in the subclassed Scene.
    #
    def base_draw
      drawers.each { |drawer| drawer.draw }
      draw
    end

    # This provides the functionality for view handling.
    include SceneView

    #
    # `transition_to` performs the work of transitioning this scene
    # to another scene.
    #
    # @param [String,Symbol,Object] scene_or_scene_name the name of the Scene which can
    #   be either the class or a string/symbol representation of the shortened scene name.
    #   This could also be an instance of scene.
    #
    def transition_to(scene_or_scene_name,options = {})
      new_scene = Scenes.generate(scene_or_scene_name,options)
      _prepare_transition(new_scene)
      window.scene = new_scene
    end

    #
    # Before a scene is transitioned away from to a new scene, this private method is
    # here to allow for any housekeeping or other work that needs to be done before
    # calling the subclasses implementation of `prepare_transition`.
    #
    # @param [Scene] new_scene this is the instance of the scene that is about to replace
    #   the current scene.
    #
    def _prepare_transition(new_scene)
      log.debug "Preparing to transition from scene #{self} to #{new_scene}"

      new_scene.class.actors.find_all {|actor_factory| actor_factory.load_from_previous_scene? }.each do |actor_factory|
        new_actor = new_scene.actor(actor_factory.name)
        current_actor = actor(actor_factory.name)
        new_actor._load current_actor._save
      end

      prepare_transition_to(new_scene)
      new_scene.prepare_transition_from(self)
    end

    #
    # Helper method that is used internally to setup the events for the specified target.
    #
    # @param [Object] target the intended target for the specified events. This object
    #   will have the appropriate methods and functionality to respond appropriately
    #   to the action blocks defined in the methods.
    #
    # @param [Array<EventFactory>] events an array of EventFactory objects that need to now
    #   be mapped to the specified target.
    #
    def register_events_for_target(target,events)
      target_relay = EventRelay.new(target,window)

      events.each do |target_event|
        target_relay.send target_event.event, *target_event.buttons, &target_event.block
      end

      event_relays.push(target_relay)
    end

    #
    # The events object that is configured through the {#events} method, which stores
    # all the gamepad and keyboard events defined. By default a scene has an event
    # relay defined. Additional relays can be defined based on the components added.
    #
    # @see Events
    # @see #add_event_relay
    #
    def event_relays
      @event_relays ||= []
    end

    #
    # This method is called during a scene update and will fire all the events
    # that have been defined for all held buttons for all defined event relays.
    #
    def fire_events_for_held_buttons
      event_relays.each do |relay|
        relay.fire_events_for_held_buttons
      end
    end

    #
    # This method is called before a scene update and passes the button up events
    # to each of the defined event relays.
    #
    def button_up(id)
      event_relays.each do |relay|
        relay.fire_button_up(id)
      end
    end

    #
    # This method is called before a scene update and passes the button down events
    # to each of the defined event relays.
    #
    def button_down(id)
      event_relays.each do |relay|
        relay.fire_button_down(id)
      end
    end


    #
    # A Scene represented as a hash currently only contains the drawers
    #
    # @return a hash of all the drawers
    #
    def to_hash
      drawn = drawers.find_all{|draw| draw.saveable? }.inject({}) do |hash,drawer|
        drawer_hash = drawer.to_hash
        hash.merge drawer_hash
      end

      drawn
    end

  end
end