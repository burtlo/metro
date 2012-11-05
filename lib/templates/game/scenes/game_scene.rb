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
      transition_to self.class.scene_name
    end
  end

end