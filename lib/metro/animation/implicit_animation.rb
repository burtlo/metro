require_relative 'easing'

class ImplicitAnimation < Animation

  attr_reader :attributes
  attr_reader :deltas

  def delta_for_step(attribute)
    deltas[attribute].at(current_step)
  end

  def stepping(stepping)
    @steppings ||= begin
      hash = Hash.new(Easing::Linear)
      hash.merge! linear: Easing::Linear,
        ease_in: Easing::EaseIn
    end
    @steppings[stepping]
  end

  def easing
    @easing || :linear
  end

  def after_initialize
    @deltas = {}

    @attributes = to.map { |attribute,final| attribute }

    to.each do |attribute,final|
      start = actor.send(attribute)
      deltas[attribute] = stepping(easing).calculate(start,final,interval)
    end

  end

  def execute_step
    attributes.each do |attribute|
      actor.send "#{attribute}=", delta_for_step(attribute)
    end
  end

end