require_relative 'scene_view/scene_view'
require_relative 'events'

module Metro
  class Scene
    attr_reader :window, :_events

    include SceneView

    def initialize(window)
      @window = window
      @_events = Events.new(self)
      events(@_events)
      show
    end

    def events(e) ; end

    def show ; end

    def update ; end

    def draw ; end

    def _no_action ; end

  end
end