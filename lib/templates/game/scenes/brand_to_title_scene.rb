class BrandToTitleScene < Metro::Scene

  draws :title

  animate actor: :title, to: { alpha: 255 }, interval: 120 do
    transition_to :title
  end

  event :on_up, Gosu::KbEscape do
    transition_to :title
  end

end