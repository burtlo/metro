require_relative 'scene_view/scene_view'
require_relative 'scene_view/components/drawer'
require_relative 'event_relay'

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
    # The window is the main instance of the game. Using window can access a lot of
    # underlying Metro::Window, a subclass of Gosu::Window, that the Scene class is
    # obfuscating.
    #
    # @see Metro::Window
    # @see Gosu::Window
    #
    attr_reader :window

    #
    # The events object that is configured through the {#events} method, which stores
    # all the gamepad and keyboard events defined.
    #
    # @see Events
    #
    attr_reader :event_relays

    #
    # Customized views that contain elements to be drawn will be handled by the
    # view_drawer.
    #
    # @see SceneView::Drawer
    #
    attr_reader :view_drawer

    #
    # Captures all classes that subclass Scene.
    #
    def self.inherited(base)
      scenes << base
    end

    #
    # All subclasses of Scene, this should be all the defined scenes
    # within the game.
    #
    # @return an Array of Scene subclasses
    #
    def self.scenes
      @scenes ||= []
    end

    # This provides the functionality for view handling.
    include SceneView

    #
    # A scene is created with a window instance. When subclassing a Scene, you should
    # hopefully not need to create an {#initialize} method or call `super` but instead
    # implement the {#show} method which is the point of incision in the subclasses
    # that allow for the subclasses of Scene to be setup correctly.
    #
    def initialize(window)
      @window = window

      @event_relays ||= []

      @scene_events = EventRelay.new(self,window)
      events(@scene_events)

      @event_relays << @scene_events

      @view_drawer = SceneView::Drawer.new(self)

      show
    end

    #
    # This method should be defined in the Scene subclass.
    #
    # @param [Events] e is the object that you can register button presses
    #
    def events(e) ; end

    def add_event_relay(event_relay)
      @event_relays << event_relay
    end

    #
    # This method is called during a scene update and will fire all the events
    # that have been defined for all held buttons for all defined event relays.
    #
    def fire_events_for_held_buttons
      event_relays.each do |er|
        er.fire_events_for_held_buttons
      end
    end

    def button_up(id)
      event_relays.each do |er|
        er.button_up(id)
      end
    end

    def button_down(id)
      event_relays.each do |er|
        er.button_down(id)
      end
    end

    #
    # This method is solely a non-action method for when events are triggered
    # for button up and button down
    #
    def _no_action ; end

    # This method is called right after initialization
    def show ; end

    #
    # This method handles the logic or game loop for the scene.
    #
    # @note This method should be implemented in the subclassed Scene
    #
    def update ; end

    #
    # The `draw_with_view` method is called by the Game Window to allow for any view related
    # drawing needs to be handled before calling the traditional `draw` method defined
    # in the subclassed Scenes.
    #
    def draw_with_view
      view_drawer.draw(view)
      draw
    end

    #
    # This method handles all the visual rendering of the scene.
    #
    # @note This method should be implemented in the subclassed Scene
    #
    def draw ; end

    #
    # `transition_to` performs the work of transitioning this scene
    # to another scene.
    #
    # @param [String,Symbol,Class] scene_name the name of the Scene which can be either
    #   the class or a string/symbol representation of the shortened scene name.
    #
    def transition_to(scene_name)
      new_scene = Scenes.create(scene_name,window)
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
      prepare_transition(new_scene)
    end

    #
    # Before a scene is transisitioned away from to a new scene, this method is called
    # to allow for the scene to complete any taskss, stop any actions, or pass any
    # information from the existing scene to the scene that is about to replace it.
    #
    # @note This method should be implemented in the subclassed Scene
    #
    # @param [Scene] new_scene this is the instance of the scene that is about to replace
    #   the current scene.
    #
    def prepare_transition(new_scene) ; end

  end
end