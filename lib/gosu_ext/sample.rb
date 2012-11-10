module Metro

  #
  # Sample is a wrapper class for a Gosu Sample. This allows for additional data to be stored
  # without relying on monkey-patching on functionality.
  #
  class Sample < SimpleDelegator

    attr_accessor :sample, :path

    def initialize(sample,path)
      super(sample)
      @sample = sample
      @path = path
    end

  end
end
