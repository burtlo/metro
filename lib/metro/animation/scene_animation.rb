require_relative 'animation'

module Metro

  module SceneAnimation
    extend self

    def build(options,&block)
      animation = Metro::ImplicitAnimation.new options
      animation.on_complete(&block) if block
      animation
    end

  end

end