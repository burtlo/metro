module Metro

  class SceneAnimation

    attr_reader :options, :on_complete_block

    def initialize(options = {},&block)
      @options = options
      @on_complete_block = block
    end

  end

end