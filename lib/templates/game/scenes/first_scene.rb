class FirstScene < GameScene

  draw :hero, position: Game.center

  draws :first_instruction, :second_instruction

  def update
    hero.position = Point.new (hero.x % Game.width), (hero.y % Game.height)
  end

end
