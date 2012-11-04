class BrandToTitleScene < GameScene

  draws :title

  animate :title, to: { alpha: 255 }, interval: 2.seconds do
    transition_to :title
  end

  event :cancel do
    transition_to :title
  end

end