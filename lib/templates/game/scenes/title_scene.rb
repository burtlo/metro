class TitleScene < GameScene

  draw :title

  draw :menu, options: [ 'Start Game', 'Exit' ]

  event :on_up, KbEscape do
    exit
  end

  def start_game
    transition_to :first
  end

end