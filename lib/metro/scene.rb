require_relative 'scene_view/scene_view'
require_relative 'scene_actor'
require_relative 'scene_animation'
require_relative 'event_relay'
require_relative 'animation/animation'

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

    #
    # As Scene does a lot of work for you with regarding to setting up content, it is
    # best not to override #initialize and instead define an #after_initialize method
    # within the subclasses of Scene.
    #
    # @note This method should be implemented in the Scene subclass.
    #
    def after_initialize ; end

    #
    # The events method is where a scene has access to configure the events that it
    # would like to listen for during the scene.
    #
    # @note This method should be implemented in the Scene subclass.
    #
    # @param [EventRelay] e is the EventRelay that you can register for button up,
    #   button down, or button held events.
    #
    # @see EventRelay
    #
    def events(e) ; end

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

    #
    # When an actor is defined a getter and setter method is defined. However, it is
    # a better interface internally not to rely heavily on send and have this small
    # amount of obfuscation in the event that this needs to change.
    # 
    # @return the actor with the given name.
    # 
    def actor(name)
      send(name)
    end

    #
    # Define a scene actor with the given name and options.
    #
    def self.draw(actor_name,options = {})
      scene_actor = SceneActor.new actor_name, options

      define_method actor_name do
        instance_variable_get("@#{actor_name}")
      end

      define_method "#{actor_name}=" do |value|
        instance_variable_set("@#{actor_name}",value)
      end

      scene_actors.push scene_actor
    end

    #
    # Define several standard scene actors.
    #
    def self.draws(*actor_names)
      actor_names = actor_names.flatten.compact

      actor_names.each do |actor_name|
        draw actor_name
      end

      scene_actors
    end

    #
    # @return a list of all the SceneActors that have been defined for this Scene.
    #
    def self.scene_actors
      @scene_actors ||= []
    end

    def self.animate(options,&block)
      scene_animation = SceneAnimation.new options, &block
      scene_animations.push scene_animation
    end

    def self.scene_animations
      @scene_animations ||= []
    end

    #
    # Setups up the Actors for the Scene based on the SceneActors that have been
    # defined.
    #
    # @note this method should not be overriden, otherwise the actors will perish!
    # @see #after_initialize
    #
    def initialize
      self.class.scene_actors.each do |scene_actor|
        actor_data = { 'name' => scene_actor.name }.merge (view[scene_actor.name] || {})
        actor_instance = scene_actor.create(actor_data)
        actor_instance.scene = self
        send "#{scene_actor.name}=", actor_instance
      end

      after_initialize
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

      @event_relays = []

      @scene_events = EventRelay.new(self,window)
      events(@scene_events)

      @event_relays << @scene_events

      @updaters = []

      @drawers = []

      self.class.scene_actors.each do |scene_actor|
        actor = send(scene_actor.name)
        actor.window = window
        @drawers << actor
      end

      self.class.scene_animations.each do |animation|
        animate animation.options, &animation.on_complete_block
      end

      show
    end

    #
    # Allows you to set or retrieve the scene name for the Scene.
    #
    # @example Retrieving the default scene name
    #
    #     class ExampleScene
    #       def show
    #         puts "Showing Scene: #{self.class.scene_name}"
    #       end
    #     end
    #
    #     ExampleScene.scene_name
    #
    # @example Setting a custom name for the Scene
    #
    #     class RollingCreditsScene
    #       scene_name "credits"
    #     end
    #
    # @param [String] scene_name when specified it will set the scene name for the class
    #   to the value specified.
    #
    # @return the String name of the scene which it can be used as a reference for transitioning
    #   or for generating the appropriate view information.
    #
    def self.scene_name(scene_name=nil)
      @scene_name ||= begin
        root_name = to_s.gsub(/Scene$/,'')
        root_name.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
        root_name.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
        root_name.downcase!
        root_name
      end

      scene_name ? @scene_name = scene_name.to_s : @scene_name
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
      scenes << base
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
      @updaters << updater
    end

    #
    # A simplier syntax to enqueue an animation. At the moment this animation is going
    # to be an implicit animation.
    #
    def animate(options,&block)
      options[:actor] = actor(options[:actor]) if options[:actor].is_a? Symbol
      animation = Metro::ImplicitAnimation.new options.merge(context: self)
      animation.on_complete(&block) if block
      enqueue animation
    end

    #
    # The `base_update` method is called by the Game Window. This is to allow for any
    # special update needs to be handled before calling the traditional `update` method
    # defined in the subclassed Scene.
    #
    def base_update
      @updaters.each { |updater| updater.update }
      update
    end

    #
    # The `base_draw` method is called by the Game Window. This is to allow for any
    # special drawing needs to be handled before calling the traditional `draw` method
    # defined in the subclassed Scene.
    #
    def base_draw
      @drawers.each { |drawer| drawer.draw }
      draw
    end

    # This provides the functionality for view handling.
    include SceneView

    #
    # `transition_to` performs the work of transitioning this scene
    # to another scene.
    #
    # @param [String,Symbol,Class] scene_name the name of the Scene which can be either
    #   the class or a string/symbol representation of the shortened scene name.
    #
    def transition_to(scene_name)
      new_scene = Scenes.generate(scene_name)
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

      new_scene.class.scene_actors.find_all {|actor| actor.load_from_previous_scene? }.each do |scene_actor|
        new_actor = new_scene.send(scene_actor.name)
        current_actor = send(scene_actor.name)
        new_actor._load current_actor._save
      end

      prepare_transition_to(new_scene)
      new_scene.prepare_transition_from(self)
    end

    #
    # The events object that is configured through the {#events} method, which stores
    # all the gamepad and keyboard events defined. By default a scene has an event
    # relay defined. Additional relays can be defined based on the components added.
    #
    # @see Events
    # @see #add_event_relay
    #
    attr_reader :event_relays

    #
    # Add an additional event relay to the list of event relays. It is appended
    # to the end of the list of relays.
    #
    # @param [EventRelay] event_relay an event relay instance that will now
    #   receive events generated from this scene.
    #
    def add_event_relay(event_relay)
      @event_relays << event_relay
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
        relay.button_up(id)
      end
    end

    #
    # This method is called before a scene update and passes the button down events
    # to each of the defined event relays.
    #
    def button_down(id)
      event_relays.each do |relay|
        relay.button_down(id)
      end
    end

  end
end