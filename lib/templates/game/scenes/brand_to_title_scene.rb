class BrandToTitleScene < Metro::Scene

  draws :title

  animate :title, to: { alpha: 255 }, interval: 120 do
    transition_to :title
  end

  event :cancel do
    transition_to :title
  end

end