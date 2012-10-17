require_relative 'scene_view/scene_view'
require_relative 'scene_view/drawer'
require_relative 'events'

module Metro
  class Scene
    attr_reader :window, :_events, :view_drawer

    def self.inherited(base)
      scenes << base
    end

    def self.scenes
      @scenes ||= []
    end

    include SceneView

    def initialize(window)
      @window = window

      @_events = Events.new(self)
      events(@_events)

      @view_drawer = SceneView::Drawer.new(self)

      show
    end

    def events(e) ; end

    def _no_action ; end

    def show ; end

    def update ; end

    def _draw
      view_drawer.draw
      draw
    end

    def draw ; end

    def transition_to(scene_name)
      new_scene = Scenes.create(scene_name,window)
      _prepare_transition(new_scene)
      window.scene = new_scene
    end

    def _prepare_transition(new_scene)
      log.debug "Preparing to transition from scene #{self} to #{new_scene}"
      prepare_transition(new_scene)
    end

    def prepare_transition(new_scene) ; end

  end
end