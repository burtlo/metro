class FirstScene < GameScene
  
  if Game.debug?
    draw :fps, model: "metro::ui::fps", placement: 'bottom_right'
  end

  draw :hero, position: Game.center

  draws :first_instruction, :second_instruction, :third_instruction, 
    :fourth_instruction, :fifth_instruction

  after 1.second do
    fade_in_and_out :first_instruction do
      fade_in_and_out :second_instruction do
        fade_in_and_out :third_instruction do
          fade_in_and_out :fourth_instruction do
            fade_in_and_out :fifth_instruction
          end
        end
      end
    end
  end

  def update
    hero.position = Point.new (hero.x % Game.width), (hero.y % Game.height)
  end

end
