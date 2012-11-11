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
      Metro.reload!
      transition_to scene_name
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


end
