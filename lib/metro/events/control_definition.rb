module Metro
  class ControlDefinition
    attr_accessor :name, :event, :args

    def initialize(name,event,args)
      @name = name
      @event = event
      @args = args
    end
  end
end