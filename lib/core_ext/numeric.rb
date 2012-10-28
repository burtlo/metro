class Numeric

  #
  # Set the tick interval which is used in conversion of seconds to
  # ticks. By default
  #
  def self.tick_interval=(value)
    @tick_interval = value.to_f
  end

  #
  # @return the game tick interval.
  #
  def self.tick_interval
    @tick_interval.to_f == 0 ? 16.666666 : @tick_interval.to_f
  end



  #
  # Provides the suffix 'second' which will translate seconds to
  # game ticks. This is to allow for a number of seconds to be expressed
  # in situations where game ticks are used (e.g. animations).
  #
  # @example Expressing an animation that takes place over 3 seconds (180 ticks)
  #
  #     class ExampleScene < Metro::Scene
  #       draws :title
  #
  #       animate :title, to: { x: 320, y: 444 }, interval: 3.seconds
  #     end
  #
  def second
    (self * 1000 / Numeric.tick_interval).floor
  end

  alias_method :seconds, :second
  alias_method :secs, :second
  alias_method :sec, :second

  #
  # Provides the suffix 'tick' which will simply express the number
  # with a vanity suffix.
  #
  # @example Expressing an animation that takes place over 60 game ticks
  #
  #     class ExampleScene < Metro::Scene
  #       draws :title
  #
  #       animate :title, to: { x: 320, y: 444 }, interval: 60.ticks
  #     end
  #
  def tick
    self
  end

  alias_method :ticks, :tick

end