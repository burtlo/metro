class GameScene < Metro::Scene

  #
  # The game scene is a place where you can define actors and
  # events here that will be present within all the subclassed
  # scenes.

  #
  # @example Setting up the ability for all subclassed scenes
  #   to be reloaded with the 'Ctrl+R' event
  #
  event :on_up, KbR do |event|
    if event.control?
      if Metro.game_has_valid_code?
        after(1.tick) { Metro.reload! ; transition_to(scene_name) }
      end
    end
  end

  #
  # @example Setting up the ability for all subclassed scenes
  #   to be edited with the 'Ctrl+E' event
  #
  event :on_up, KbE do |event|
    if event.control?
      transition_to scene_name, with: :edit
    end
  end

  #
  # This animation helper will fade in and fade out information.
  #
  def fade_in_and_out(name)
    animate name, to: { alpha: 255 }, interval: 2.seconds do
      after 1.second do
        animate name, to: { alpha: 0 }, interval: 1.second do
          yield if block_given?
        end
      end
    end
  end

end
