module Metro
  module Game
    extend self
    Background, Stars, Players, UI = *0..3
    Width, Height = 640, 480

    def center
      [ Width / 2 , Height / 2 ]
    end
  end
end