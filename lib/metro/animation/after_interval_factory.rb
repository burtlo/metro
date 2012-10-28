module Metro
  
  class AfterIntervalFactory
    attr_reader :ticks, :block
    
    def initialize(ticks,&block)
      @ticks = ticks
      @block = block
    end
  end

end