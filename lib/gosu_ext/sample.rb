module Metro

  class Sample < SimpleDelegator

    attr_accessor :sample, :path

    def initialize(sample,path)
      super(sample)
      @sample = sample
      @path = path
    end

  end
end
